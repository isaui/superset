#!/bin/bash
set -e

echo "🚀 Starting Superset..."

# Check environment variables
if [ -z "$DATABASE_URL" ]; then
    echo "❌ DATABASE_URL environment variable is required!"
    exit 1
fi

if [ -z "$SECRET_KEY" ]; then
    echo "⚠️  WARNING: SECRET_KEY not set, using default (not secure for production)"
    export SECRET_KEY="default-secret-key-change-this"
fi

# Wait for database
echo "⏳ Waiting for database..."
while ! python -c "
import os
from sqlalchemy import create_engine, text
try:
    engine = create_engine(os.environ['DATABASE_URL'])
    engine.execute(text('SELECT 1'))
    print('Database ready!')
except Exception as e: 
    print(f'Database error: {e}')
    exit(1)
" 2>/dev/null; do
    echo "Database not ready, waiting..."
    sleep 2
done

# Check if database is initialized
if ! python -c "
import os
from sqlalchemy import create_engine, text
engine = create_engine(os.environ['DATABASE_URL'])
result = engine.execute(text(\"SELECT count(*) FROM information_schema.tables WHERE table_name='ab_user'\"))
if result.fetchone()[0] == 0: exit(1)
" 2>/dev/null; then
    echo "📦 Initializing Superset database..."
    superset db upgrade
    
    echo "👤 Creating admin user..."
    superset fab create-admin \
        --username admin \
        --firstname Admin \
        --lastname User \
        --email admin@superset.com \
        --password admin
    
    echo "🔧 Initializing Superset..."
    superset init
    
    echo "📊 Loading example datasets..."
    if superset load_examples 2>/dev/null; then
        echo "✅ Example datasets loaded successfully!"
    else
        echo "⚠️  Failed to load examples (might be due to memory constraints)"
    fi
    
    echo "✅ Database initialized!"
else
    echo "✅ Database already initialized!"
fi

echo "🌐 Starting Superset server..."
exec gunicorn --bind 0.0.0.0:8088 --timeout 120 --workers 2 "superset.app:create_app()"