FROM apache/superset:3.1.0

# Build arguments
ARG DATABASE_URL
ARG SECRET_KEY

# Switch to root
USER root

# Install PostgreSQL driver
RUN pip install --no-cache-dir psycopg2-binary

# Copy files
COPY superset_config.py /app/pythonpath/
COPY entrypoint.sh /app/entrypoint.sh

# Create persistent directories and set permissions
RUN mkdir -p /app/superset_home/uploads \
    && chown -R superset:superset /app/superset_home \
    && chown -R superset:superset /app/pythonpath \
    && chmod +x /app/entrypoint.sh

# Switch back to superset user
USER superset

# Set environment variables from build args
ENV DATABASE_URL=${DATABASE_URL}
ENV SECRET_KEY=${SECRET_KEY}

# Set environment
ENV SUPERSET_CONFIG_PATH=/app/pythonpath/superset_config.py
ENV SUPERSET_HOME=/app/superset_home

# Volume for persistent data
VOLUME ["/app/superset_home"]

# Expose port
EXPOSE 8088

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8088/health || exit 1

# Use entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]