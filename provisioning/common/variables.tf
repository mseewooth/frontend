variable "env" {                  # 1. Create an input variable named "env" (short for environment)
    type        = string          # 2. Enforce that the input must be text (a string)
    description =  "dev"            # 3. (Typo here, needs quotes) A note explaining what this variable is for
}                                 # 4. Close the variable block

variable "aws_region" {           # 5. Create an input variable named "aws_region"
    type    = string              # 6. Enforce that this input must be text
    default = "eu-west-2"         # 7. If you don't provide a region, automatically use London (eu-west-2)
}  