# Pull base image
FROM python:3.12-slim-trixie

# Install UV
COPY --from=ghcr.io/astral-sh/uv:0.10.9 /uv /uvx /bin/

# Set work directory
WORKDIR /hello-world-dock

# Set environment variables
ENV PYTHONUNBUFFERED=1

ENV PYTHONDONTWRITEBYTECODE=1

ENV UV_COMPILE_BYTECODE=1
    
ENV UV_LINK_MODE=copy

ENV UV_TOOL_BIN_DIR=/usr/local/bin


# Install dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project

# Copy Project
COPY . .

# Run using uv
CMD ["uv", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]