curl -X POST http://localhost:9090/-/reload

# Reload configuration
POST http://localhost:9090/-/reload

# Graceful shutdown  
POST http://localhost:9090/-/quit

# Check readiness
GET http://localhost:9090/-/ready

# Check health
GET http://localhost:9090/-/healthy