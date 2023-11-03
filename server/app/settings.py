from flongo_framework.config.settings import App_Settings, Flask_Settings, MongoDB_Settings, JWT_Settings
from flongo_framework.config.enums.logs.log_levels import LOG_LEVELS

# Application Settings (Can be overridden by env)
SETTINGS = App_Settings(
    flask=Flask_Settings(
        env="local", 
        debug_mode=True,
        log_level=LOG_LEVELS.DEBUG,
        config_log_level=LOG_LEVELS.DEBUG
    ),
    mongodb=MongoDB_Settings(
        log_level=LOG_LEVELS.DEBUG
    ),
    jwt=JWT_Settings(
        enable_csrf_protection=True
    )
)
