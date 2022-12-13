module "redis" {
    source = "./redis"
}

module "flask" {
    source = "./flask"

    redis_ready = [module.redis.redis_ready]
}