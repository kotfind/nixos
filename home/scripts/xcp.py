import sys
from os.path import relpath
from pathlib import Path

import pyclip
from click import Context, argument, echo, group, option, pass_context, style
from click import Path as ClickPath

# -------------------- Constants --------------------

ECHO_MAX_LEN: int = 80
ECHO_ELLIPSIS: str = "..."
ECHO_PREFIX: str = "Copied: "


# -------------------- Clipboard helpers --------------------


def _copy(data: str | bytes) -> None:
    pyclip.copy(data)
    text = _format_copied(data)
    label = style(ECHO_PREFIX, bold=True)
    echo(f"{label}{text}", color=True)


def _format_copied(data: str | bytes) -> str:
    if isinstance(data, bytes):
        try:
            data = data.decode()
        except UnicodeDecodeError:
            return "<binary>"
    limit = ECHO_MAX_LEN - len(ECHO_PREFIX)
    if len(data) > limit:
        return data[: limit - len(ECHO_ELLIPSIS)] + ECHO_ELLIPSIS
    return data


# -------------------- Cli --------------------


@group(
    context_settings={"help_option_names": ["-h", "--help"]},
    invoke_without_command=True,
)
@pass_context
def cli(ctx: Context) -> None:
    """Copy paths, file contents, or stdin to the clipboard."""

    if ctx.invoked_subcommand is None:
        _copy(sys.stdin.buffer.read())


@cli.command("rel")
@argument("file", type=ClickPath(exists=True))
@option(
    "-f",
    "--from",
    "from_dir",
    type=ClickPath(exists=True, file_okay=False, dir_okay=True),
    help=(
        "Directory to evaluate FILE relative to (default: current directory)."
    ),
)
def cli_rel(file: str, from_dir: str | None) -> None:
    """Copy FILE's path relative to a directory (cwd by default)."""

    file_abs = Path(file).resolve()
    from_rel = Path.cwd() if from_dir is None else Path(from_dir)
    from_abs = from_rel.resolve()
    path = relpath(file_abs, from_abs)
    _copy(path)


@cli.command("abs")
@argument("file", type=ClickPath(exists=True))
def cli_abs_(file: str) -> None:
    """Copy FILE's absolute path."""

    path = Path(file).resolve()
    _copy(str(path))


@cli.command("file")
@argument("file", type=ClickPath(exists=True, dir_okay=False))
def cli_file(file: str) -> None:
    """Copy FILE's contents."""

    data = Path(file).read_bytes()
    _copy(data)


# -------------------- Main --------------------


if __name__ == "__main__":
    cli()
