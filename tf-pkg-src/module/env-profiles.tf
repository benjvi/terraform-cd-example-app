
variable "record_ttl" {
  type = "map"
  default = {
    default = 120
    test = 120
    prod = 240
  }
}

