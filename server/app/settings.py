from flongo_framework.config.settings import App_Settings, Flask_Settings, MongoDB_Settings
from flongo_framework.config.enums.logs.log_levels import LOG_LEVELS

# Application Settings (Can be overridden by env)
SETTINGS = App_Settings(
    flask=Flask_Settings(
        env="local", 
        debug_mode=True, 
        log_level=LOG_LEVELS.DEBUG,
        config_log_level=LOG_LEVELS.DEBUG,
        # Local Development
        cors_origins=["http://localhost:*", "http://0.0.0.0:*"]
    ),
    mongodb=MongoDB_Settings(
        log_level=LOG_LEVELS.DEBUG
    ),
)
