import logging
import pathlib
import sys

from dynaconf import Dynaconf

from apipe.scripts.config import read_config

CONFIG_PATH = pathlib.Path(__file__).parent
ROOT_DIR = CONFIG_PATH.parent.parent

settings = Dynaconf(
    envvar_prefix="DYNACONF",
    settings_files=[
        CONFIG_PATH / "settings.yaml",
        CONFIG_PATH / ".secrets.yaml",
    ],
)

write_default_scalars = Dynaconf(
    envvar_prefix="DYNACONF",
    settings_files=[
        CONFIG_PATH / "write_default_scalars.yml",
        CONFIG_PATH / ".secrets.yaml",
    ],
)

map_ts = Dynaconf(
    envvar_prefix="DYNACONF",
    settings_files=[
        CONFIG_PATH / "map_ts.yml",
        CONFIG_PATH / ".secrets.yaml",
    ],
)


class LevelFilter(logging.Filter):
    def __init__(self, level):
        self.level = level
        super(LevelFilter, self).__init__()

    def filter(self, record):
        return record.levelno != self.level


DEBUG = settings.get("DEBUG", False)
LOGGING_LEVEL = settings.get(
    "LOGGING_LEVEL", logging.DEBUG if DEBUG else logging.INFO
)

root_logger = logging.getLogger()
root_logger.handlers.clear()  # Remove the default handler
root_logger.setLevel(LOGGING_LEVEL)

stream_formatter = logging.Formatter("%(levelname)s - %(message)s")
stream_handler = logging.StreamHandler()
stream_handler.setFormatter(stream_formatter)
stream_handler.addFilter(LevelFilter(logging.ERROR))
root_logger.addHandler(stream_handler)

DEFAULT_LOGFILE = "snake.log"


def add_snake_logger(rulename):
    """
    Adds logging to file

    Logfile is read from input parameters, ending with ".log"
    This is done in order to add loggers for subprocesses
    (like data_preprocessing.py), where logfile is unknown.
    """
    logger = logging.getLogger(rulename)
    logfile = next(
        (item for item in sys.argv if item.endswith(".log")), DEFAULT_LOGFILE
    )
    handler = logging.FileHandler(logfile)
    file_formatter = logging.Formatter(
        "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    )
    handler.setFormatter(file_formatter)
    logger.addHandler(handler)
    return logger


def load_yaml(file_path):
    return read_config(file_path)


LABELS = load_yaml(CONFIG_PATH / "labels" / f"{settings.labels}.yml")
raw_colors = load_yaml(CONFIG_PATH / "colors.yml")
COLOR_DICT = {}
for label, color in raw_colors.items():
    if label not in LABELS:
        continue
    COLOR_DICT[LABELS[label]] = color
    COLOR_DICT[f"{LABELS[label]} in"] = color
    COLOR_DICT[f"{LABELS[label]} out"] = color
