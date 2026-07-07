hl.monitor({
    output = "desc:SAM",
    mode = "1920x1080@75.00",
    position = "0x0",
    scale = "1",
    transform = 0,
})

hl.monitor({
    output = "desc:ACR",
    mode = "1920x1080@143.85",
    position = "0x0",
    scale = "1",
    transform = 0,
})

-- Fallback
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1
})
