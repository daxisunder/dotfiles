-- main monitor (TV)
hl.monitor({
	output = "HDMI-A-3",
	mode = "3840x2160@60",
	position = "0x0",
	scale = "1.5",
	bitdepth = "10",
	cm = "auto",
})

-- QEMU-KVM
hl.monitor({
	output = "Virtual-1",
	mode = "1920x1080@60",
	position = "auto",
	scale = "1.0",
	bitdepth = "auto",
	cm = "auto",
})
