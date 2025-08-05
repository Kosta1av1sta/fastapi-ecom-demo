from pydantic import BaseModel, SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict

__all__ = (
    "Settings",
    "settings",
)


class CORSSettings(BaseModel):
    allow_origins: list[str]
    allow_credentials: bool
    allow_methods: list[str]
    allow_headers: list[str]


class PostgresSettings(BaseModel):
    user: str
    password: SecretStr
    db: str
    port: str
    host: str
    schema: str  # type: ignore

    @property
    def dsn(self) -> str:
        db = self
        return (
            f"postgresql+asyncpg://"
            f"{db.user}:{db.password.get_secret_value()}"
            f"@{db.host}:{db.port}/{db.db}"
        )


class Settings(BaseSettings):
    APP_TIMEZONE: str
    APP_NAME: str
    API_URL: str
    FRONTEND_MAIN_PAGE_URL: str
    CORS: CORSSettings
    POSTGRES: PostgresSettings

    debug: bool = False

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        env_nested_delimiter="__",
    )


settings = Settings()
