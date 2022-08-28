# USERS
resource "aws_iam_user" "edward-earley" {
  name = "edward.q.earley"
}
resource "aws_iam_user" "eks" {
  name = "eks"
}

# GROUPS
resource "aws_iam_group" "eks-admins" {
  name = "eks-admins"
}
resource "aws_iam_group_membership" "eks-admins" {
  name = "eks-admins"

  users = [
    "${aws_iam_user.edward-earley.name}"
    "${aws_iam_user.eks.name}",
  ]
  group = aws_iam_group.eks-admins.name
}
resource "aws_iam_group_policy_attachment" "eks-admins" {
  group      = aws_iam_group.eks-admins.name
  policy_arn = aws_iam_policy.eks-admins.arn
}
resource "aws_iam_group_policy_attachment" "eks-admins-password" {
  group      = aws_iam_group.eks-admins.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}
# ROLES

# POLICIES
resource "aws_iam_policy" "eks-admins" {
  name        = "eks-admins"
  path        = "/"
  description = "eks-admins"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
