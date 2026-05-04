# This block defines the value we want to display
output "greeting" {
  value = "Hello, World!"
}
output "greeting2" {
  value =  tolist(["a", "b", 3])
}

