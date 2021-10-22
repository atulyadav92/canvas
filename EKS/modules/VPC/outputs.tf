output "vpc_id" {
  value = aws_vpc.vpc_canvas.id
}
output "subnet_pvt_id" {
  value = aws_subnet.sbn_canvas_pvt.*.id
}
output "subnet_pbl_id" {
  value = aws_subnet.sbn_canvas_pbl.*.id
}