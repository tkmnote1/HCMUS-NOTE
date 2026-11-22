// ============================================================
// BÌA XÁC SUẤT — TRƯỜNG ĐH KHOA HỌC TỰ NHIÊN (ĐHQG-HCM)
// Typst, khổ A4. Đặt logo-hcmus.png cùng thư mục với file này.
// ============================================================

#set page(
  paper: "a4",
  margin: 0cm,
  numbering: none,
  header: none,
  footer: none,
)
#set text(font: "New Computer Modern", lang: "vi", size: 12pt)

// Khung viền kép: căn đối xứng theo bốn mép trang A4.
#place(
  top + left,
  dx: 1.6cm,
  dy: 1.7cm,
  rect(width: 17.8cm, height: 26.3cm, stroke: 2.2pt + black),
)
#place(
  top + left,
  dx: 1.72cm,
  dy: 1.82cm,
  rect(width: 17.56cm, height: 26.06cm, stroke: 0.8pt + black),
)

// Tên trường, khoa.
#place(top + center, dy: 3.0cm)[
  #block(width: 17cm)[
    #align(center)[
      #text(size: 14pt, weight: "bold")[TRƯỜNG ĐẠI HỌC KHOA HỌC TỰ NHIÊN]
      #v(0.30cm)
      #text(size: 13pt)[KHOA TOÁN - TIN HỌC]
    ]
  ]
]

// Logo gốc (giữ nguyên màu xanh và tỉ lệ ảnh).
#place(top + center, dy: 6.0cm)[
  #image("logo-hcmus.png", width: 6.4cm)
]

// Tên tài liệu và phụ đề.
#place(top + center, dy: 14.1cm)[
  #block(width: 17cm)[
    #align(center)[
      #text(size: 18pt, weight: "bold")[XÁC SUẤT]
      #v(1.25cm)
      #text(size: 14pt, style: "italic")[Lý thuyết và Bài Tập]
    ]
  ]
]

// Tác giả và ngày tháng (tự cập nhật ngày khi biên dịch).
#place(top + center, dy: 24.0cm)[
  #block(width: 17cm)[
    #align(center)[
      #text(size: 14pt)[Khuong]
      #v(0.92cm)
      #text(size: 12pt)[Thành phố Hồ Chí Minh, ngày #datetime.today().display("[day] tháng [month] năm [year]")]
    ]
  ]
]
