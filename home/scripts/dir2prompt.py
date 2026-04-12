from pathlib import Path


def is_path_ignored(path: Path):
    exclude_names = [".git", ".direnv", "build", "target", ".gitignore"]

    if path.name in exclude_names:
        return True

    if "cache" in path.name:
        return True

    if "lock" in path.name:
        return True

    return False


def is_path_contents_hidden(path: Path):
    exclude_exts = [
        ".zip",
        ".rar",
        ".bin",
        ".sqlite",
        ".db",
        ".pdf",
        ".jpg",
        ".png",
        ".jpeg",
        ".webp",
        ".gz",
        ".tar",
    ]

    if path.suffix in exclude_exts:
        return True

    return False


def print_tree(path: Path, depth: int = 0):
    indent = " " * 4 * depth
    for entry_path in sorted(path.iterdir()):
        if is_path_ignored(entry_path):
            continue

        print(f"{indent}{entry_path.name}")

        if entry_path.is_dir():
            print_tree(entry_path, depth + 1)


def print_file_contents_rec(path: Path, base_path: Path):
    for entry_path in sorted(path.iterdir()):
        if is_path_ignored(entry_path):
            continue

        if entry_path.is_file() and not is_path_contents_hidden(entry_path):
            rel_path = entry_path.relative_to(base_path)
            print(f"The contents of `{rel_path}`:")

            lines = entry_path.read_text(errors="backslashreplace").splitlines()
            lines = [line for line in lines]
            contents = "\n".join(lines)

            print("```")
            print(contents)
            print("```")
            print()

        if entry_path.is_dir():
            print_file_contents_rec(entry_path, base_path)


if __name__ == "__main__":
    print("The file structure:")
    print("```")
    print_tree(Path.cwd(), 0)
    print("```")
    print()

    print("File contents are the following:")
    print_file_contents_rec(Path.cwd(), Path.cwd())
