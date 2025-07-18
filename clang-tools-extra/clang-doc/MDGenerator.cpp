//===-- MDGenerator.cpp - Markdown Generator --------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Generators.h"
#include "Representation.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/FormatVariadic.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/raw_ostream.h"
#include <string>

using namespace llvm;

namespace clang {
namespace doc {

// Markdown generation

static std::string genItalic(const Twine &Text) {
  return "*" + Text.str() + "*";
}

static std::string genEmphasis(const Twine &Text) {
  return "**" + Text.str() + "**";
}

static std::string
genReferenceList(const llvm::SmallVectorImpl<Reference> &Refs) {
  std::string Buffer;
  llvm::raw_string_ostream Stream(Buffer);
  for (const auto &R : Refs) {
    if (&R != Refs.begin())
      Stream << ", ";
    Stream << R.Name;
  }
  return Stream.str();
}

static void writeLine(const Twine &Text, raw_ostream &OS) {
  OS << Text << "\n\n";
}

static void writeNewLine(raw_ostream &OS) { OS << "\n\n"; }

static void writeHeader(const Twine &Text, unsigned int Num, raw_ostream &OS) {
  OS << std::string(Num, '#') + " " + Text << "\n\n";
}

static void writeSourceFileRef(const ClangDocContext &CDCtx, const Location &L,
                               raw_ostream &OS) {

  if (!CDCtx.RepositoryUrl) {
    OS << "*Defined at " << L.Filename << "#"
       << std::to_string(L.StartLineNumber) << "*";
  } else {

    OS << formatv("*Defined at [#{0}{1}{2}](#{0}{1}{3})*",
                  CDCtx.RepositoryLinePrefix.value_or(""), L.StartLineNumber,
                  L.Filename, *CDCtx.RepositoryUrl);
  }
  OS << "\n\n";
}

static void maybeWriteSourceFileRef(llvm::raw_ostream &OS,
                                    const ClangDocContext &CDCtx,
                                    const std::optional<Location> &DefLoc) {
  if (DefLoc)
    writeSourceFileRef(CDCtx, *DefLoc, OS);
}

static void writeDescription(const CommentInfo &I, raw_ostream &OS) {
  switch (I.Kind) {
  case CommentKind::CK_FullComment:
    for (const auto &Child : I.Children)
      writeDescription(*Child, OS);
    break;

  case CommentKind::CK_ParagraphComment:
    for (const auto &Child : I.Children)
      writeDescription(*Child, OS);
    writeNewLine(OS);
    break;

  case CommentKind::CK_BlockCommandComment:
    OS << genEmphasis(I.Name);
    for (const auto &Child : I.Children)
      writeDescription(*Child, OS);
    break;

  case CommentKind::CK_InlineCommandComment:
    OS << genEmphasis(I.Name) << " " << I.Text;
    break;

  case CommentKind::CK_ParamCommandComment:
  case CommentKind::CK_TParamCommandComment: {
    std::string Direction = I.Explicit ? (" " + I.Direction).str() : "";
    OS << genEmphasis(I.ParamName) << I.Text << Direction;
    for (const auto &Child : I.Children)
      writeDescription(*Child, OS);
    break;
  }

  case CommentKind::CK_VerbatimBlockComment:
    for (const auto &Child : I.Children)
      writeDescription(*Child, OS);
    break;

  case CommentKind::CK_VerbatimBlockLineComment:
  case CommentKind::CK_VerbatimLineComment:
    OS << I.Text;
    writeNewLine(OS);
    break;

  case CommentKind::CK_HTMLStartTagComment: {
    if (I.AttrKeys.size() != I.AttrValues.size())
      return;
    std::string Buffer;
    llvm::raw_string_ostream Attrs(Buffer);
    for (unsigned Idx = 0; Idx < I.AttrKeys.size(); ++Idx)
      Attrs << " \"" << I.AttrKeys[Idx] << "=" << I.AttrValues[Idx] << "\"";

    std::string CloseTag = I.SelfClosing ? "/>" : ">";
    writeLine("<" + I.Name + Attrs.str() + CloseTag, OS);
    break;
  }

  case CommentKind::CK_HTMLEndTagComment:
    writeLine("</" + I.Name + ">", OS);
    break;

  case CommentKind::CK_TextComment:
    OS << I.Text;
    break;

  case CommentKind::CK_Unknown:
    OS << "Unknown comment kind: " << static_cast<int>(I.Kind) << ".\n\n";
    break;
  }
}

static void writeNameLink(const StringRef &CurrentPath, const Reference &R,
                          llvm::raw_ostream &OS) {
  llvm::SmallString<64> Path = R.getRelativeFilePath(CurrentPath);
  // Paths in Markdown use POSIX separators.
  llvm::sys::path::native(Path, llvm::sys::path::Style::posix);
  llvm::sys::path::append(Path, llvm::sys::path::Style::posix,
                          R.getFileBaseName() + ".md");
  OS << "[" << R.Name << "](" << Path << ")";
}

static void genMarkdown(const ClangDocContext &CDCtx, const EnumInfo &I,
                        llvm::raw_ostream &OS) {
  if (I.Scoped)
    writeLine("| enum class " + I.Name + " |", OS);
  else
    writeLine("| enum " + I.Name + " |", OS);
  writeLine("--", OS);

  std::string Buffer;
  llvm::raw_string_ostream Members(Buffer);
  if (!I.Members.empty())
    for (const auto &N : I.Members)
      Members << "| " << N.Name << " |\n";
  writeLine(Members.str(), OS);

  maybeWriteSourceFileRef(OS, CDCtx, I.DefLoc);

  for (const auto &C : I.Description)
    writeDescription(C, OS);
}

static void genMarkdown(const ClangDocContext &CDCtx, const FunctionInfo &I,
                        llvm::raw_ostream &OS) {
  std::string Buffer;
  llvm::raw_string_ostream Stream(Buffer);
  bool First = true;
  for (const auto &N : I.Params) {
    if (!First)
      Stream << ", ";
    Stream << N.Type.QualName + " " + N.Name;
    First = false;
  }
  writeHeader(I.Name, 3, OS);
  StringRef Access = getAccessSpelling(I.Access);
  writeLine(genItalic(Twine(Access) + (!Access.empty() ? " " : "") +
                      (I.IsStatic ? "static " : "") +
                      I.ReturnType.Type.QualName.str() + " " + I.Name.str() +
                      "(" + Twine(Stream.str()) + ")"),
            OS);

  maybeWriteSourceFileRef(OS, CDCtx, I.DefLoc);

  for (const auto &C : I.Description)
    writeDescription(C, OS);
}

static void genMarkdown(const ClangDocContext &CDCtx, const NamespaceInfo &I,
                        llvm::raw_ostream &OS) {
  if (I.Name == "")
    writeHeader("Global Namespace", 1, OS);
  else
    writeHeader("namespace " + I.Name, 1, OS);
  writeNewLine(OS);

  if (!I.Description.empty()) {
    for (const auto &C : I.Description)
      writeDescription(C, OS);
    writeNewLine(OS);
  }

  llvm::SmallString<64> BasePath = I.getRelativeFilePath("");

  if (!I.Children.Namespaces.empty()) {
    writeHeader("Namespaces", 2, OS);
    for (const auto &R : I.Children.Namespaces) {
      OS << "* ";
      writeNameLink(BasePath, R, OS);
      OS << "\n";
    }
    writeNewLine(OS);
  }

  if (!I.Children.Records.empty()) {
    writeHeader("Records", 2, OS);
    for (const auto &R : I.Children.Records) {
      OS << "* ";
      writeNameLink(BasePath, R, OS);
      OS << "\n";
    }
    writeNewLine(OS);
  }

  if (!I.Children.Functions.empty()) {
    writeHeader("Functions", 2, OS);
    for (const auto &F : I.Children.Functions)
      genMarkdown(CDCtx, F, OS);
    writeNewLine(OS);
  }
  if (!I.Children.Enums.empty()) {
    writeHeader("Enums", 2, OS);
    for (const auto &E : I.Children.Enums)
      genMarkdown(CDCtx, E, OS);
    writeNewLine(OS);
  }
}

static void genMarkdown(const ClangDocContext &CDCtx, const RecordInfo &I,
                        llvm::raw_ostream &OS) {
  writeHeader(getTagType(I.TagType) + " " + I.Name, 1, OS);

  maybeWriteSourceFileRef(OS, CDCtx, I.DefLoc);

  if (!I.Description.empty()) {
    for (const auto &C : I.Description)
      writeDescription(C, OS);
    writeNewLine(OS);
  }

  std::string Parents = genReferenceList(I.Parents);
  std::string VParents = genReferenceList(I.VirtualParents);
  if (!Parents.empty() || !VParents.empty()) {
    if (Parents.empty())
      writeLine("Inherits from " + VParents, OS);
    else if (VParents.empty())
      writeLine("Inherits from " + Parents, OS);
    else
      writeLine("Inherits from " + Parents + ", " + VParents, OS);
    writeNewLine(OS);
  }

  if (!I.Members.empty()) {
    writeHeader("Members", 2, OS);
    for (const auto &Member : I.Members) {
      StringRef Access = getAccessSpelling(Member.Access);
      writeLine(Twine(Access) + (Access.empty() ? "" : " ") +
                    (Member.IsStatic ? "static " : "") +
                    Member.Type.Name.str() + " " + Member.Name.str(),
                OS);
    }
    writeNewLine(OS);
  }

  if (!I.Children.Records.empty()) {
    writeHeader("Records", 2, OS);
    for (const auto &R : I.Children.Records)
      writeLine(R.Name, OS);
    writeNewLine(OS);
  }
  if (!I.Children.Functions.empty()) {
    writeHeader("Functions", 2, OS);
    for (const auto &F : I.Children.Functions)
      genMarkdown(CDCtx, F, OS);
    writeNewLine(OS);
  }
  if (!I.Children.Enums.empty()) {
    writeHeader("Enums", 2, OS);
    for (const auto &E : I.Children.Enums)
      genMarkdown(CDCtx, E, OS);
    writeNewLine(OS);
  }
}

static void genMarkdown(const ClangDocContext &CDCtx, const TypedefInfo &I,
                        llvm::raw_ostream &OS) {
  // TODO support typedefs in markdown.
}

static void serializeReference(llvm::raw_fd_ostream &OS, Index &I, int Level) {
  // Write out the heading level starting at ##
  OS << "##" << std::string(Level, '#') << " ";
  writeNameLink("", I, OS);
  OS << "\n";
}

static llvm::Error serializeIndex(ClangDocContext &CDCtx) {
  std::error_code FileErr;
  llvm::SmallString<128> FilePath;
  llvm::sys::path::native(CDCtx.OutDirectory, FilePath);
  llvm::sys::path::append(FilePath, "all_files.md");
  llvm::raw_fd_ostream OS(FilePath, FileErr, llvm::sys::fs::OF_Text);
  if (FileErr)
    return llvm::createStringError(llvm::inconvertibleErrorCode(),
                                   "error creating index file: " +
                                       FileErr.message());

  CDCtx.Idx.sort();
  OS << "# All Files";
  if (!CDCtx.ProjectName.empty())
    OS << " for " << CDCtx.ProjectName;
  OS << "\n\n";

  for (auto C : CDCtx.Idx.Children)
    serializeReference(OS, C, 0);

  return llvm::Error::success();
}

static llvm::Error genIndex(ClangDocContext &CDCtx) {
  std::error_code FileErr;
  llvm::SmallString<128> FilePath;
  llvm::sys::path::native(CDCtx.OutDirectory, FilePath);
  llvm::sys::path::append(FilePath, "index.md");
  llvm::raw_fd_ostream OS(FilePath, FileErr, llvm::sys::fs::OF_Text);
  if (FileErr)
    return llvm::createStringError(llvm::inconvertibleErrorCode(),
                                   "error creating index file: " +
                                       FileErr.message());
  CDCtx.Idx.sort();
  OS << "# " << CDCtx.ProjectName << " C/C++ Reference\n\n";
  for (auto C : CDCtx.Idx.Children) {
    if (!C.Children.empty()) {
      const char *Type;
      switch (C.RefType) {
      case InfoType::IT_namespace:
        Type = "Namespace";
        break;
      case InfoType::IT_record:
        Type = "Type";
        break;
      case InfoType::IT_enum:
        Type = "Enum";
        break;
      case InfoType::IT_function:
        Type = "Function";
        break;
      case InfoType::IT_typedef:
        Type = "Typedef";
        break;
      case InfoType::IT_concept:
        Type = "Concept";
        break;
      case InfoType::IT_variable:
        Type = "Variable";
        break;
      case InfoType::IT_friend:
        Type = "Friend";
        break;
      case InfoType::IT_default:
        Type = "Other";
      }
      OS << "* " << Type << ": [" << C.Name << "](";
      if (!C.Path.empty())
        OS << C.Path << "/";
      OS << C.Name << ")\n";
    }
  }
  return llvm::Error::success();
}

/// Generator for Markdown documentation.
class MDGenerator : public Generator {
public:
  static const char *Format;

  llvm::Error generateDocs(StringRef RootDir,
                           llvm::StringMap<std::unique_ptr<doc::Info>> Infos,
                           const ClangDocContext &CDCtx) override;
  llvm::Error createResources(ClangDocContext &CDCtx) override;
  llvm::Error generateDocForInfo(Info *I, llvm::raw_ostream &OS,
                                 const ClangDocContext &CDCtx) override;
};

const char *MDGenerator::Format = "md";

llvm::Error
MDGenerator::generateDocs(StringRef RootDir,
                          llvm::StringMap<std::unique_ptr<doc::Info>> Infos,
                          const ClangDocContext &CDCtx) {
  // Track which directories we already tried to create.
  llvm::StringSet<> CreatedDirs;

  // Collect all output by file name and create the necessary directories.
  llvm::StringMap<std::vector<doc::Info *>> FileToInfos;
  for (const auto &Group : Infos) {
    doc::Info *Info = Group.getValue().get();

    llvm::SmallString<128> Path;
    llvm::sys::path::native(RootDir, Path);
    llvm::sys::path::append(Path, Info->getRelativeFilePath(""));
    if (!CreatedDirs.contains(Path)) {
      if (std::error_code Err = llvm::sys::fs::create_directories(Path);
          Err != std::error_code()) {
        return llvm::createStringError(Err, "Failed to create directory '%s'.",
                                       Path.c_str());
      }
      CreatedDirs.insert(Path);
    }

    llvm::sys::path::append(Path, Info->getFileBaseName() + ".md");
    FileToInfos[Path].push_back(Info);
  }

  for (const auto &Group : FileToInfos) {
    std::error_code FileErr;
    llvm::raw_fd_ostream InfoOS(Group.getKey(), FileErr,
                                llvm::sys::fs::OF_Text);
    if (FileErr) {
      return llvm::createStringError(FileErr, "Error opening file '%s'",
                                     Group.getKey().str().c_str());
    }

    for (const auto &Info : Group.getValue()) {
      if (llvm::Error Err = generateDocForInfo(Info, InfoOS, CDCtx)) {
        return Err;
      }
    }
  }

  return llvm::Error::success();
}

llvm::Error MDGenerator::generateDocForInfo(Info *I, llvm::raw_ostream &OS,
                                            const ClangDocContext &CDCtx) {
  switch (I->IT) {
  case InfoType::IT_namespace:
    genMarkdown(CDCtx, *static_cast<clang::doc::NamespaceInfo *>(I), OS);
    break;
  case InfoType::IT_record:
    genMarkdown(CDCtx, *static_cast<clang::doc::RecordInfo *>(I), OS);
    break;
  case InfoType::IT_enum:
    genMarkdown(CDCtx, *static_cast<clang::doc::EnumInfo *>(I), OS);
    break;
  case InfoType::IT_function:
    genMarkdown(CDCtx, *static_cast<clang::doc::FunctionInfo *>(I), OS);
    break;
  case InfoType::IT_typedef:
    genMarkdown(CDCtx, *static_cast<clang::doc::TypedefInfo *>(I), OS);
    break;
  case InfoType::IT_concept:
  case InfoType::IT_variable:
  case InfoType::IT_friend:
    break;
  case InfoType::IT_default:
    return createStringError(llvm::inconvertibleErrorCode(),
                             "unexpected InfoType");
  }
  return llvm::Error::success();
}

llvm::Error MDGenerator::createResources(ClangDocContext &CDCtx) {
  // Write an all_files.md
  auto Err = serializeIndex(CDCtx);
  if (Err)
    return Err;

  // Generate the index page.
  Err = genIndex(CDCtx);
  if (Err)
    return Err;

  return llvm::Error::success();
}

static GeneratorRegistry::Add<MDGenerator> MD(MDGenerator::Format,
                                              "Generator for MD output.");

// This anchor is used to force the linker to link in the generated object
// file and thus register the generator.
volatile int MDGeneratorAnchorSource = 0;

} // namespace doc
} // namespace clang
