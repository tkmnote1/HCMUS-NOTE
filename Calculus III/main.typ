#import "@preview/euler-math:0.1.0": *
#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.0"
// ==========================================
// CÀI ĐẶT MÀU SẮC & BIẾN ĐẾM
// ==========================================
#let color-prop = rgb("#009688")  // Xanh ngọc (Mệnh đề) - nổi bật
#let bg-prop = rgb("#e0f2f1")     // Nền xanh ngọc nhạt

#let color-thm = rgb("#c00040")   // Đỏ thẫm (Định lí)
#let bg-thm = rgb("#fdf2f4")
#let color-cau = rgb("#B4A0CB")   // Đỏ nâu
#let bg-cau = rgb("#F8F5FC")      // Nền đỏ rất nhạt


#let color-lem = rgb("#2e7d32")   // Xanh lá (Bổ đề)
#let bg-lem = rgb("#e8f5e9")


#let color-prob = rgb("#006080")  // Xanh lam (Bài toán)
#let bg-prob = rgb("#f0f7fb")

#let color-def = rgb("#6a0dad")   // Tím (Định nghĩa)
#let bg-def = rgb("#f8f1fa")

#let color-ex = rgb("#536B83") // Xanh (Ví dụ)
#let bg-ex = rgb("#EDF2F7")

#let color-text = rgb("#005a8c")  // Màu chữ cho Chứng minh/Lời giải

#let thm-counter = counter("theorem")

// ==========================================
// HÀM TEMPLATE CHÍNH
// ==========================================
#let template(
  title: none,
  subtitle: none,
  author: none,
  body
) = {
  // Bật font Euler cho công thức toán học
  show math.equation: set text(font: "New Computer Modern Math",size: 10pt)

  // Cấu hình trang (Lề trái phải x: 1.5cm)
  set page(
    paper: "a4",
    margin: (x: 1.5cm, y: 2cm),
    header: context {
      let current-page = here().page()
      
      // Ẩn thanh ngang (header) ở trang bìa
      if title != none and current-page == 1 {
        return none
      }

      let page-num = counter(page).display("1")
      let elems = query(heading.where(level: 1))
      
      let active-h1 = none
      let on-page = elems.filter(e => e.location().page() == current-page)
      
      if on-page.len() > 0 {
        active-h1 = on-page.first()
      } else {
        let before-page = elems.filter(e => e.location().page() < current-page)
        if before-page.len() > 0 {
          active-h1 = before-page.last() 
        }
      }
      
      let current-title = if active-h1 != none { active-h1.body } else { [] }
      
      let current-num = if active-h1 != none and active-h1.numbering != none { 
        let n = counter(heading).at(active-h1.location()).first()
        [#text(fill: color-thm)[§#n] #h(0.3em)]
      } else { [] }
      
      grid(
        columns: (1fr, auto),
        align(left)[*#current-num#text(fill: black)[#current-title]*],
        align(right)[*#page-num*]
      )
      v(-0.5em)
      line(length: 100%, stroke: 0.5pt)
    },
    numbering: "1"
  )
  
  // Cấu hình văn bản toàn cục
  set text(font: "New Computer Modern", size: 11pt, lang: "vi")
  set par(justify: true, leading: 1.4em, spacing: 1.2em)

  // Cấu hình đánh số heading 
  set heading(numbering: "1.1")

  // Tùy biến Mục lục
  show outline.entry.where(level: 1): it => {
    v(1em, weak: true)
    text(fill: color-text, weight: "bold")[#it]
  }
  show outline.entry.where(level: 2): it => {
    text(fill: color-text)[#it]
  }
  
  // Cấu hình lại giao diện Heading
  show heading.where(level: 1): it => {
    thm-counter.update(0) 
    block(above: 1.5em, below: 1em)[
      #if it.numbering != none {
        text(fill: color-thm, size: 15pt)[*§ #counter(heading).display()*]
        h(0.3em)
      }
      #text(fill: black, size: 15pt)[*#it.body*]
    ]
  }
  
  show heading.where(level: 2): it => {
    block(above: 1.2em, below: 0.8em)[
      #if it.numbering != none {
        text(fill: color-thm, size: 12pt)[*§#counter(heading).display()*]
        h(0.3em)
      }
      #text(fill: black, size: 12pt)[*#it.body*]
    ]
  }

  // ==========================================
  // TẠO TRANG BÌA
  // ==========================================

  body
}
// Tạo Trang Bìa

//
// ==========================================
// HÀM TẠO BOX ĐỊNH lí, BỔ ĐỀ, BÀI TOÁN
// ==========================================
#let math-box(title: none, prefix: "", color: black, bg: white, body) = {
  thm-counter.step()
  context {
    let ch = counter(heading.where(level: 1)).get().first()
    let thm = thm-counter.get().first()
    let num = str(ch) + "." + str(thm)
    
    let header = text(fill: color, weight: "bold")[#prefix #num]
    if title != none {
      header += text(fill: color, weight: "bold")[ (#title)]
    }
    
    block(
      fill: bg,
      width: 100%,
      inset: (top: 10pt, bottom: 10pt, left: 12pt, right: 12pt),
      spacing: 1.2em,
      radius: 0pt,
      stroke: (left: 3pt + color ),
      breakable: true,
      [
        #set par(justify: true, leading: 1.4em) // Ép căn đều bên trong Box
        #header
        #v(0.4em, weak: true) 
        #body
      ]
    )
  }
}
#set text(size: 13pt)
#show math.equation: set text(size: 9pt)
#let y(label) = block(above: 10pt, below: 7pt)[
  #text(size: 9pt, weight: "bold")[#label)]
]
#let menhde(title: none, body) = math-box(title: title, prefix: "Mệnh đề", color: color-prop, bg: bg-prop, body)
#let dinhly(title: none, body) = math-box(title: title, prefix: "Định lí", color: color-thm, bg: bg-thm, body)
#let bode(title: none, body) = math-box(title: title, prefix: "Bổ đề", color: color-lem, bg: bg-lem, body)
#let baitoan(title: none, body) = math-box(title: title, prefix: "Bài toán", color: color-prob, bg: bg-prob, body)
#let dinhnghia(title: none, body) = math-box(title: title, prefix: "Định nghĩa", color: color-def, bg: bg-def, body)
#let cau(title: none, body) = math-box(title: title, prefix: "Bài", color: color-cau, bg: bg-cau, body)
#let vidu(title: none, body) = math-box(title: title, prefix: "Ví dụ", color: color-ex, bg: bg-ex, body)
#let chungminh(body) = block(spacing: 1.2em, width: 100%)[
  #set par(justify: true, leading: 1.4em) // Ép căn đều bên trong Chứng minh
  #text(fill: color-text, weight: "bold")[Chứng minh.] #body #h(1fr) $square$
]

#let loigiai(body) = block(spacing: 1.2em, width: 100%)[
  #set par(justify: true, leading: 1.4em) // Ép căn đều bên trong Lời giải
  #text(fill: color-text, weight: "bold")[Lời giải.] #body #h(1fr) $square$
]

#let baitap(num: "", body) = block(spacing: 1.2em, width: 100%)[
  #set par(justify: true, leading: 1.4em) // Ép căn đều bên trong Bài tập
  #text(fill: color-text, weight: "bold")[Bài tập #num.] #body
]

// ==========================================
// BẮT ĐẦU NỘI DUNG VĂN BẢN
// ==========================================

#show: template.with(
  title: "Giải Tích 3A",
  subtitle: "HCMUS",
  author: "Khương"
)

// Tạo Trang Bìa 
#include "trang_bia_hcmus/bia_xac_suat.typ"

#pagebreak()

// Khôi phục định dạng trang cho nội dung chính
#set page(
  paper: "a4",
  margin: (x: 1.5cm, y: 2cm),
  numbering: "1",
)

// Phần nội dung tài liệu
#outline(title: "Mục lục")

#pagebreak()

//

// Gọi lại Mục lục ở đây 
= Tuần 1
== Hình hộp và thể tích của hình hộp
#dinhnghia[
  Một *hình hộp $n$-chiều* trong $RR^n$ là một tập con của $RR^n$ có dạng

$
[a_1,b_1] times [a_2,b_2] times dots times [a_n,b_n]
$

với $a_i < b_i$ với mọi $1 <= i <= n$, tức là tích của $n$ đoạn thẳng, là tập hợp

$
{(x_1,x_2,...,x_n) in RR^n | forall 1 <= i <= n, a_i <= x_i <= b_i}.
$
Ta muốn ứng với mỗi hình hộp một số thực gọi là thể tích của hình hộp.
Đại lượng thể tích này, là một đại lượng đo lường, cần có tính cộng và tính
không đổi qua phép dời hình.
]

#dinhnghia[
  *Thể tích $n$-chiều* của hình hộp

$
[a_1,b_1] times [a_2,b_2] times dots times [a_n,b_n]
$

là số thực

$
(b_1 - a_1)(b_2 - a_2) dots (b_n - a_n).
$

Ta thường dùng kí hiệu $|I|$ để chỉ thể tích của $I$. Từ “thể tích” thường được thay bằng từ *chiều dài* khi số chiều $n = 1$ và *diện tích* khi $n = 2$.
]
== Chia nhỏ hình hộp
#dinhnghia[
  Một *phép chia* hay một *phân hoạch* của một khoảng $[a,b]$ là một tập con hữu hạn của khoảng $[a,b]$ mà chứa cả $a$ và $b$. Ta có thể đặt tên các phần tử của một phép chia là $x_0, x_1, ..., x_m$ với $a = x_0 < x_1 < x_2 < dots < x_m = b$. Mỗi khoảng $[x_(i-1), x_i]$ là một *khoảng con* của khoảng $[a,b]$ ứng với phép chia.

Một phép chia của hình hộp $I = product_(i=1)^n [a_i,b_i]$ là một tích của các phép chia của các khoảng $[a_i,b_i]$. Cụ thể nếu mỗi $P_i$ là một phép chia của khoảng $[a_i,b_i]$ thì $P = product_(i=1)^n P_i$ là một phép chia của hình hộp $I$. Xem hình 1.

Một *hình hộp con* ứng với một phép chia $P$ của một hình hộp $I$ là một tích các khoảng con của các cạnh của hình hộp $I$. Cụ thể một hình hộp con của hình hộp $I$ có dạng $product_(i=1)^n T_i$ trong đó $T_i$ là một khoảng con của khoảng $[a_i,b_i]$ ứng với phép chia $P_i$. Xem Hình 1.6.

Kí hiệu $H(P)$ là tập hợp tất cả các hình hộp con ứng với phép chia $P$. Ta gọi *độ mịn* của phép chia $P$, kí hiệu bằng $norm(P)$, là chiều dài cạnh lớn nhất trong các hình hộp con của $P$.
]
#figure(
  cetz.canvas({
    import cetz.draw: *

    // Các tọa độ phân hoạch
    let xs = (1.2, 2.2, 3.6, 4.5, 5.8)
    let ys = (1.0, 2.2, 3.0, 3.9)

    // Tô miền R
    rect(
      (1.2, 1.0),
      (5.8, 3.9),
      fill: rgb("#a9c9e8"),
      stroke: blue + 1pt,
    )

    // Trục tọa độ
    line((0.3, 0.3), (0.3, 4.8), stroke: 0.8pt)
    line((0.3, 0.3), (6.5, 0.3), stroke: 0.8pt)

    // Mũi tên trục y
    line((0.3, 4.8), (0.2, 4.55), stroke: 0.8pt)
    line((0.3, 4.8), (0.4, 4.55), stroke: 0.8pt)

    // Mũi tên trục x
    line((6.5, 0.3), (6.25, 0.2), stroke: 0.8pt)
    line((6.5, 0.3), (6.25, 0.4), stroke: 0.8pt)

    // Các đường chia theo phương x
    for x in xs {
      line(
        (x, 0.3),
        (x, 3.9),
        stroke: (paint: black, thickness: 0.6pt, dash: "dotted"),
      )
    }

    // Các đường chia theo phương y
    for y in ys {
      line(
        (0.3, y),
        (5.8, y),
        stroke: (paint: black, thickness: 0.6pt, dash: "dotted"),
      )
    }

    // Vẽ lại biên hình chữ nhật
    rect(
      (1.2, 1.0),
      (5.8, 3.9),
      stroke: blue + 1pt,
    )

    // Các điểm của phép chia
    for x in xs {
      for y in ys {
        circle((x, y), radius: 0.035, fill: black)
      }
    }

    // Nhãn trục
    content((6.7, 0.15), [$x$])
    content((0.05, 5.0), [$y$])

    // Nhãn a, b, c, d
    content((1.2, 0.05), [$a$])
    content((5.8, 0.05), [$b$])
    content((0.0, 1.0), [$c$])
    content((0.0, 3.9), [$d$])

    // Nhãn miền R
    content((3.45, 2.55), [$R$])
  }),
  caption: [
    Một phép chia của hình chữ nhật $[a,b] times [c,d]$ gồm những
    điểm mà các tọa độ thứ nhất tạo thành một phép chia của $[a,b]$
    và các tọa độ thứ hai tạo thành một phép chia của $[c,d]$.
    Các hình chữ nhật con có các cạnh là các khoảng con.
  ],
)
#pagebreak()
== Tích phân trên hình hộp
#dinhnghia[
  Cho $I$ là một hình hộp, và $f: I -> RR$. Với một phép chia $P$ của $I$ theo ý tưởng ở trên, ta thành lập *tổng Riemann*, là tổng trên tất cả hình hộp con $R$ của phép chia $P$ của giá trị của $f$ tại một điểm đại diện (còn gọi là điểm lấy mẫu) bất kì $x_R$ trong $R$ nhân với thể tích của $R$:

$
sum_(R in H(P)) f(x_R) |R|.
$
]
#vidu[
  Xét hàm $f(x,y) = x + 2y$ trên hình chữ nhật $[0,4] times [0,2]$. Chia đều hình chữ nhật này thành 4 phần bằng kích thước, cụ thể dùng các điểm chia với các tọa độ $x_0 = 0$, $x_1 = 2$, $x_2 = 4$, $y_0 = 0$, $y_1 = 1$, $y_2 = 2$. Độ mịn của phép chia này là chiều dài cạnh lớn nhất của các hình chữ nhật con, là $2$. Xem Hình 2.
  

Lấy điểm đại diện trên mỗi hình chữ nhật con là điểm giữa của hình chữ nhật con. Tổng Riemann tương ứng là
$
[f(1;0,5) + f(3;0,5) + f(1;1,5) + f(3;1,5)] times 2 times 1
= [2 + 4 + 4 + 6] times 2
= 32.
$
]
#figure(
  cetz.canvas({
    import cetz.draw: *

    // Lưới nền
    grid(
      (-0.5, -0.5),
      (5, 3),
      step: 0.1,
      stroke: rgb("#dddddd") + 0.3pt,
    )

    grid(
      (-0.4, -0.4),
      (4.7, 2.7),
      step: 0.5,
      stroke: rgb("#aaaaaa") + 0.5pt,
    )

    // Trục tọa độ
    line(
      (-0.5, 0),
      (5, 0),
      mark: (end: ">"),
      stroke: black + 0.8pt,
    )

    line(
      (0, -1.),
      (0, 3.05),
      mark: (end: ">"),
      stroke: black + 0.8pt,
    )

    // Miền [0,4] x [0,2]
    rect(
      (0, 0),
      (4, 2),
      fill: rgb("#f3e8df"),
      stroke: rgb("#b85c25") + 2pt,
    )

    // Hai đường chia
    line(
      (2, 0),
      (2, 2),
      stroke: (paint: black, thickness: 1pt, dash: "dashed"),
    )

    line(
      (0, 1),
      (4, 1),
      stroke: (paint: black, thickness: 1pt, dash: "dashed"),
    )

    // Các điểm của phân hoạch
    let partition-points = (
      (0,0), (2,0), (4,0),
      (0,1), (2,1), (4,1),
      (0,2), (2,2), (4,2),
    )

    for p in partition-points {
      circle(
        p,
        radius: 0.035,
        fill: rgb("#5d78e8"),
        stroke: black + 1.5pt,
      )
    }

    // Các điểm giữa
    let midpoints = (
      (1,0.5),
      (3,0.5),
      (1,1.5),
      (3,1.5),
    )

    for p in midpoints {
      circle(
        p,
        radius: 0.04,
        fill: rgb("#e54262"),
        stroke: black + 0.5pt,
      )
    }

    // Nhãn trên trục x
    content((-0.3, -0.2), [$0$])
    content((0.5, -0.23), [$0,5$])
    content((1, -0.2), [$1$])
    content((1.5, -0.23), [$1,5$])
    content((2, -0.2), [$2$])
    content((2.5, -0.23), [$2,5$])
    content((3, -0.2), [$3$])
    content((3.5, -0.23), [$3,5$])
    content((4, -0.2), [$4$])
    content((4.5, -0.23), [$4,5$])

    // Nhãn trên trục y
    content((-0.4, .5), [$0,5$])
    content((-0.4, 1), [$1$])
    content((-0.4, 1.5), [$1,5$])
    content((-0.4, 2), [$2$])
    content((-0.4, 2.5), [$2,5$])
  }),

  caption: [
    Chia đều hình chữ nhật $[0,4] times [0,2]$ thành 4 phần bằng kích thước,
    và lấy điểm giữa của hình chữ nhật con làm điểm đại diện.
  ],
)
#vidu[
  Khi số chiều $n = 1$, Định nghĩa 1.10 trùng với định nghĩa tích phân của hàm một biến trong môn Vi tích phân 1 và ở trung học, với $integral_[a,b] f$ chính là $integral_a^b f(x) dif x$. Như vậy *ta thừa hưởng tất cả các kết quả về tích phân hàm một biến đã có trong Vi tích phân 1*, trong đó có công thức Newton–Leibniz để tính tích phân. Chẳng hạn ta có

$
integral_[0,1] x dif x
= integral_0^1 x dif x
= 1/2 x^2 |_ (x=0) ^ (x=1)
= 1/2.
$
]
#vidu[
  Khi $n = 2$ ta thường gọi tích phân là *tích phân bội hai*, thường được viết là $integral.double_I f(x,y) dif A$ hay $integral.double_I f(x,y) dif x dif y$.

Khi $n = 3$ ta thường gọi tích phân là *tích phân bội ba*, thường được viết là $integral.triple_I f(x,y,z) dif V$ hay $integral.triple_I f(x,y,z) dif x dif y dif z$.

Trong môn này các kí hiệu $dif x$, $dif x dif y$, $dif x dif y dif z$, $dif A$, $dif V$ được dùng để chỉ loại tích phân, không có ý nghĩa độc lập.
]
== Tổng dưới và tổng trên
#dinhnghia[
  Tiếp theo ta tìm hiểu một cách trình bày bằng tổng dưới và tổng trên, cũng cho ra tích phân Riemann, giúp ta hiểu rõ hơn tổng Riemann và là công cụ chính để xét tính khả tích.

Cách trình bày này đòi hỏi ta chỉ xét những hàm bị chặn. Giả sử hàm $f$ bị chặn. Gọi

$
L(f,P) = sum_(R in H(P)) (inf_R f) |R|
$

là *tổng dưới* ứng với $P$. Gọi

$
U(f,P) = sum_(R in H(P)) (sup_R f) |R|
$

là *tổng trên* ứng với $P$.

Với phép chia cho trước thì tổng Riemann bất kì nằm giữa tổng dưới và tổng trên.
]
#vidu[
   Nếu hàm $f$ liên tục thì trên mỗi hình hộp con $R$ hàm $f$ đạt được giá trị nhỏ nhất và giá trị lớn nhất, tức là $inf_R f = min_R f$, $sup_R f = max_R f$. Nhắc rằng điều này là từ các kết quả quan trọng sau trong Giải tích 2.

(a) Một tập con của $RR^n$ là compắc khi và chỉ khi nó đóng và bị chặn.

(b) Một hàm thực liên tục trên một tập con compắc của $RR^n$ thì bị chặn, hơn nữa có giá trị nhỏ nhất và giá trị lớn nhất.

Do đó trong trường hợp hàm liên tục thì các tổng dưới và tổng trên là các tổng Riemann. Xem Hình 1.12.

Tổng quát hơn, nếu trên tất cả các hình hộp con $R$ thì $inf_R f$ và $sup_R f$ đều đạt được, trở thành $min_R f$ và $max_R f$, thì tổng dưới và tổng trên là các tổng Riemann, còn ngược lại thì tổng dưới và tổng trên không phải là tổng Riemann.
]
#align(center)[
  #cetz.canvas({
    import cetz.draw: *

    // ==================================================
    // 1. Các hình chữ nhật của tổng dưới
    // ==================================================

    let blue-fill = rgb("#bdd5e7")
    let blue-line = rgb("#1595c5")
    let red-line = rgb("#ff2020")
    let green-line = rgb("#338c3a")

    rect((-4, 0), (-3, 1.0),
      fill: blue-fill,
      stroke: blue-line + 0.7pt,
    )

    rect((-3, 0), (-2, 2.4),
      fill: blue-fill,
      stroke: blue-line + 0.7pt,
    )

    rect((-2, 0), (-1, 3.3),
      fill: blue-fill,
      stroke: blue-line + 0.7pt,
    )

    rect((-1, 0), (0, 3.8),
      fill: blue-fill,
      stroke: blue-line + 0.7pt,
    )

    rect((0, 0), (1, 3.8),
      fill: blue-fill,
      stroke: blue-line + 0.7pt,
    )

    rect((1, 0), (2, 3.35),
      fill: blue-fill,
      stroke: blue-line + 0.7pt,
    )

    rect((2, 0), (3, 2.85),
      fill: blue-fill,
      stroke: blue-line + 0.7pt,
    )

    rect((3, 0), (4, 2.80),
      fill: blue-fill,
      stroke: blue-line + 0.7pt,
    )


    // ==================================================
    // 2. Lưới nhỏ
    // ==================================================

    for i in range(0, 91) {
      let x = -4.4 + i * 0.1

      line(
        (x, -0.4),
        (x, 4.8),
        stroke: (
          paint: rgb("#dddddd"),
          thickness: 0.18pt,
        ),
      )
    }

    for i in range(0, 53) {
      let y = -0.4 + i * 0.1

      line(
        (-4.4, y),
        (4.7, y),
        stroke: (
          paint: rgb("#dddddd"),
          thickness: 0.18pt,
        ),
      )
    }


    // ==================================================
    // 3. Lưới chính mỗi 0.5 đơn vị
    // ==================================================

    for i in range(0, 19) {
      let x = -4.0 + i * 0.5

      line(
        (x, -0.4),
        (x, 4.8),
        stroke: (
          paint: rgb("#aaaaaa"),
          thickness: 0.35pt,
        ),
      )
    }

    for i in range(0, 11) {
      let y = i * 0.5

      line(
        (-4.4, y),
        (4.7, y),
        stroke: (
          paint: rgb("#aaaaaa"),
          thickness: 0.35pt,
        ),
      )
    }


    // ==================================================
    // 4. Các hình chữ nhật của tổng trên
    //    Chỉ vẽ đường viền đỏ
    // ==================================================

    rect((-4, 0), (-3, 2.4),
      stroke: red-line + 0.8pt,
    )

    rect((-3, 0), (-2, 3.3),
      stroke: red-line + 0.8pt,
    )

    rect((-2, 0), (-1, 3.8),
      stroke: red-line + 0.8pt,
    )

    rect((-1, 0), (0, 4.0),
      stroke: red-line + 0.8pt,
    )

    rect((0, 0), (1, 4.0),
      stroke: red-line + 0.8pt,
    )

    rect((1, 0), (2, 3.8),
      stroke: red-line + 0.8pt,
    )

    rect((2, 0), (3, 3.4),
      stroke: red-line + 0.8pt,
    )

    rect((3, 0), (4, 3.0),
      stroke: red-line + 0.8pt,
    )


    // ==================================================
    // 5. Đồ thị f
    //    Dùng nhiều điểm gần nhau để tạo cảm giác đường cong
    // ==================================================

    line(
      (-4.00, 1.00),
      (-3.80, 1.35),
      (-3.60, 1.65),
      (-3.40, 1.92),
      (-3.20, 2.18),
      (-3.00, 2.40),

      (-2.80, 2.62),
      (-2.60, 2.82),
      (-2.40, 3.00),
      (-2.20, 3.16),
      (-2.00, 3.30),

      (-1.80, 3.43),
      (-1.60, 3.55),
      (-1.40, 3.65),
      (-1.20, 3.75),
      (-1.00, 3.83),

      (-0.80, 3.90),
      (-0.60, 3.95),
      (-0.40, 3.98),
      (-0.20, 4.00),
      (0.00, 4.00),

      (0.20, 3.99),
      (0.40, 3.96),
      (0.60, 3.92),
      (0.80, 3.86),
      (1.00, 3.80),

      (1.20, 3.72),
      (1.40, 3.63),
      (1.60, 3.53),
      (1.80, 3.43),
      (2.00, 3.32),

      (2.20, 3.20),
      (2.40, 3.08),
      (2.60, 2.98),
      (2.80, 2.90),
      (3.00, 2.84),

      (3.20, 2.80),
      (3.40, 2.78),
      (3.60, 2.79),
      (3.80, 2.86),
      (4.00, 3.00),

      stroke: green-line + 1.1pt,
    )


    // ==================================================
    // 6. Trục tọa độ
    // ==================================================

    line(
      (-4.45, 0),
      (4.65, 0),
      stroke: black + 0.7pt,
    )

    // Mũi tên trục x
    line(
      (4.65, 0),
      (4.55, 0.07),
      stroke: black + 0.7pt,
    )

    line(
      (4.65, 0),
      (4.55, -0.07),
      stroke: black + 0.7pt,
    )


    line(
      (0, -0.35),
      (0, 4.75),
      stroke: black + 0.7pt,
    )

    // Mũi tên trục y
    line(
      (0, 4.75),
      (-0.07, 4.63),
      stroke: black + 0.7pt,
    )

    line(
      (0, 4.75),
      (0.07, 4.63),
      stroke: black + 0.7pt,
    )
  })
]

#v(6pt)

#align(center)[
  Hình 1.12: Tổng dưới và tổng trên của một hàm liên tục là các tổng Riemann.
]
#bode[
   Cho $P$ và $P'$ là hai phép chia của cùng một hình hộp.

(a) *Chia mịn hơn thì tổng dưới tăng và tổng trên giảm:* Nếu $P'$ mịn hơn $P$ thì

$
L(f,P) <= L(f,P') <= U(f,P') <= U(f,P).
$

(b) *Tổng dưới nhỏ hơn hay bằng tổng trên:*

$
L(f,P) <= U(f,P').
$
]
#chungminh[
  Ta viết chứng minh cho trường hợp tổng quát, 

*(a)* Mỗi hình hộp con $R'$ của $P'$ chứa trong một hình hộp con $R$ của $P$. Trên tập con thì inf tăng lên, nên

$
inf_(R') f >= inf_R f.
$

Vì thế, với mỗi $R in H(P)$,

$
sum_(R' subset R, R' in H(P')) (inf_(R') f) |R'|
>=
sum_(R' subset R, R' in H(P')) (inf_R f) |R'|
$

$
= inf_R f
sum_(R' subset R, R' in H(P')) |R'|
= (inf_R f)|R|.
$

Lấy tổng hai vế của bất đẳng thức trên theo tất cả hình hộp con $R$ của $P$, ta được

$
L(f,P') >= L(f,P).
$

Tương tự, trên tập con thì sup giảm xuống, nên

$
sup_(R') f <= sup_R f.
$

Do đó, với mỗi $R in H(P)$,

$
sum_(R' subset R, R' in H(P')) (sup_(R') f) |R'|
<=
sum_(R' subset R, R' in H(P')) (sup_R f) |R'|
$

$
= sup_R f
sum_(R' subset R, R' in H(P')) |R'|
= (sup_R f)|R|.
$

Lấy tổng theo tất cả $R in H(P)$, ta được

$
U(f,P') <= U(f,P).
$

Mặt khác, với mọi phép chia $P'$ ta luôn có

$
L(f,P') <= U(f,P').
$

Vậy nếu $P'$ mịn hơn $P$ thì

$
  L(f,P) <= L(f,P') <= U(f,P') <= U(f,P).
$

*(b)* 

Luôn có một phép chia $P''$ mịn hơn cả $P$ lẫn $P'$. Chẳng hạn, nếu

$
P = product_(i=1)^n P_i
quad "và" quad
P' = product_(i=1)^n P_i',
$

thì có thể lấy

$
P'' = product_(i=1)^n P_i'',
quad
P_i'' = P_i union P_i'.
$

Khi đó $P''$ mịn hơn cả $P$ và $P'$. Theo câu (a),

$
L(f,P) <= L(f,P'')
quad "và" quad
U(f,P'') <= U(f,P').
$

Mặt khác,

$
L(f,P'') <= U(f,P'').
$

Suy ra

$
L(f,P)
<= L(f,P'')
<= U(f,P'')
<= U(f,P').
$

Do đó

$
L(f,P) <= U(f,P').
$

Khi chia mịn hơn thì tổng dưới tăng lên còn tổng trên giảm đi, gần hơn tới giá trị tích phân nằm ở giữa. Đây là một ưu điểm quan trọng của tổng trên và tổng dưới so với tổng Riemann, bởi vì với tổng Riemann thì chia mịn hơn không nhất thiết dẫn tới xấp xỉ tốt hơn do còn phụ thuộc vào cách chọn điểm đại diện.
]
#dinhnghia[
  Ta nói hàm số $f: I -> RR$ trên hình hộp $I$ là *khả tích Darboux* nếu $f$ bị chặn và

$
sup_P L(f,P) = inf_P U(f,P),
$

và khi đó ta gọi *tích phân Darboux* của $f$ là số thực này,

$
integral_I f
= sup_P L(f,P)
= inf_P U(f,P).
$

Như vậy *tích phân Darboux là số thực duy nhất nằm giữa tất cả các tổng dưới và tất cả các tổng trên.*
]
#pagebreak()
#vidu[
   Với một hàm hằng $c$ trên hình hộp $I$, thì các tổng dưới và tổng trên với mọi phép chia đều bằng $c |I|$, nên hàm $c$ khả tích trên $I$ và tích phân của $c$ trên $I$ là

$
integral_I c = c |I|.
$

Ta nói ngay rằng thực sự *tích phân Riemann và tích phân Darboux trùng nhau*, vì vậy ta thường không phân biệt hai tích phân này, và gọi chung chúng là tích phân Riemann.
]
#menhde[Hàm là khả tích Darboux khi và chỉ khi khả tích Riemann, và khi
đó hai tích phân bằng nhau.
]
#vidu[
*(Không bị chặn thì không khả tích)*. Nếu một hàm không bị chặn, thì
theo định nghĩa, nó không có tích phân Darboux, nên do đó
nó cũng không có tích phân Riemann. 
]
== Tính chất của tích phân
Những tính chất căn bản sau tương tự trường hợp hàm một biến.

#menhde[
  Nếu $f$ và $g$ khả tích trên hình hộp $I$ thì:

*(a)* $f + g$ khả tích và

$
integral_I (f + g)
= integral_I f + integral_I g.
$

*(b)* Với mọi số thực $c$ thì $c f$ khả tích và

$
integral_I c f
= c integral_I f.
$

*(c)* Nếu $f <= g$ thì

$
integral_I f <= integral_I g.
$

Có thể giải thích sơ lược các tính chất này, rằng tính chất tương ứng đúng cho tổng Riemann, nên “qua giới hạn” thì vẫn đúng. Tính chất (c) nghĩa là vì đồ thị của $f$ nằm dưới đồ thị của $g$ nên thể tích của khối bên dưới đồ thị của $f$ nhỏ hơn hay bằng thể tích của khối bên dưới đồ thị của $g$, hay vì tại mỗi điểm giá trị của $f$ nhỏ hơn hay bằng giá trị của $g$ nên tổng giá trị của $f$ nhỏ hơn hay bằng tổng giá trị của $g$.
]
#chungminh[
  
  *(a)* Cho $epsilon > 0$. Vì $f$ và $g$ khả tích, với phép chia có độ mịn đủ nhỏ để mọi tổng Riemann của $f$ sai khác tích phân của $f$ nhỏ hơn $epsilon/2$, và mọi tổng Riemann của $g$ sai khác tích phân của $g$ nhỏ hơn $epsilon/2$, thì với bất kì tổng Riemann nào của $f + g$ ta có

$
abs(
  sum_R (f+g)(x_R)|R|
  - (integral_I f + integral_I g)
)
<=
abs(
  sum_R f(x_R)|R| - integral_I f
)
+
abs(
  sum_R g(x_R)|R| - integral_I g
)
< epsilon.
$

Vậy $f + g$ khả tích và

$
integral_I (f+g)
= integral_I f + integral_I g.
$

*(b)* Khi $c = 0$ kết quả đúng. Xét $c != 0$. Cho $epsilon > 0$. Vì $f$ khả tích, với phép chia có độ mịn đủ nhỏ để mọi tổng Riemann của $f$ sai khác $integral_I f$ nhỏ hơn $epsilon/abs(c)$, ta có

$
abs(
  sum_R c f(x_R)|R|
  - c integral_I f
)
=
abs(c)
abs(
  sum_R f(x_R)|R|
  - integral_I f
)
< epsilon.
$

Vậy $c f$ khả tích và

$
integral_I c f = c integral_I f.
$

*(c)* Giả sử $f <= g$. Cho $epsilon > 0$. Vì $f$ và $g$ khả tích, ta chọn một phép chia có độ mịn đủ nhỏ sao cho với cùng các điểm lấy mẫu $x_R$,

$
abs(
  sum_R f(x_R)|R| - integral_I f
) < epsilon/2
$

và

$
abs(
  sum_R g(x_R)|R| - integral_I g
) < epsilon/2.
$

Vì $f(x_R) <= g(x_R)$ với mọi $R$, nên

$
sum_R f(x_R)|R|
<=
sum_R g(x_R)|R|.
$

Do đó

$
integral_I f
<
sum_R f(x_R)|R| + epsilon/2
<=
sum_R g(x_R)|R| + epsilon/2
<
integral_I g + epsilon.
$

Vì bất đẳng thức trên đúng với mọi $epsilon > 0$, suy ra

$

  integral_I f <= integral_I g

$
]
#vidu[
   Ước lượng giá trị của tích phân sau nếu nó tồn tại

$
integral.double_([0,1] times [2,4]) x^2 y^3 dif x dif y.
$

Ta có đánh giá với $0 <= x <= 1$, $2 <= y <= 4$:

$
0 = 0^2 dot 2^3 <= x^2 y^3 <= 1^2 dot 4^3 = 64.
$

Suy ra

$
integral.double_([0,1] times [2,4]) 0 dif x dif y
<= integral.double_([0,1] times [2,4]) x^2 y^3 dif x dif y
<= integral.double_([0,1] times [2,4]) 64 dif x dif y.
$

Vậy

$
0 = 0 dot (1 - 0) dot (4 - 2)
<= integral.double_([0,1] times [2,4]) x^2 y^3 dif x dif y
<= 64 dot (1 - 0) dot (4 - 2)
= 128.
$
]
#pagebreak()
== Bài tập
#baitoan[
  *1.20.* Cho hàm số $f$ định bởi $f(x) = x^3 + 1$ trên đoạn $[2, 10]$. Hãy viết biểu thức tổng Riemann của $f$ trên $[2, 10]$ bằng cách chia đoạn này thành 16 đoạn con đều nhau, điểm lấy mẫu là trung điểm của mỗi đoạn con.
]
#loigiai[
   Chia đoạn $[2, 10]$ thành $16$ đoạn con đều nhau, khi đó

$
Delta x = (10 - 2)/16 = 1/2.
$

Các điểm chia có dạng $x_k = 2 + k/2$, với $k = 0,1,...,16$. Trung điểm của đoạn con thứ $k$ là

$
xi_k = (x_(k-1) + x_k)/2
= 2 + (2k - 1)/4
= (2k + 7)/4.
$

Do đó tổng Riemann của $f(x) = x^3 + 1$ là

$
sum_(k=1)^16 f(xi_k) Delta x
= 1/2 sum_(k=1)^16 (((2k + 7)/4)^3 + 1).
$

Vậy

$
 (1/2 sum_(k=1)^16 (((2k + 7)/4)^3 + 1)).
$
]
#baitoan[
  *1.21.* Một chiếc xe di chuyển thẳng theo một chiều, với tốc độ tức thời tại thời điểm $t$ là $v(t)$ (đơn vị là $k m/h$). Ta có dữ liệu tốc độ định kì mỗi 30 phút trong bảng sau.

#align(center)[
  #table(
    columns: 8,
    align: center,
    stroke: 0.7pt,
    inset: (x: 10pt, y: 5pt),
    [$t$],    [$0$], [$0,5$], [$1$], [$1,5$], [$2$], [$2,5$], [$3$],
    [$v(t)$], [$0$], [$60$],  [$80$], [$70$],  [$55$], [$80$],  [$60$],
  )
]

Hãy ước lượng chiều dài quãng đường đi được.
]
#loigiai[
   Khoảng thời gian giữa hai lần đo liên tiếp là

$
Delta t = 0,5 " giờ".
$

Trên mỗi khoảng thời gian, ta ước lượng vận tốc trung bình bằng trung bình cộng của vận tốc tại hai đầu khoảng. Do đó quãng đường xe đi được xấp xỉ

$
s approx 0,5 [
  (0 + 60)/2
  + (60 + 80)/2
  + (80 + 70)/2
  + (70 + 55)/2
  + (55 + 80)/2
  + (80 + 60)/2
].
$

Suy ra

$
s approx 187,5 k m.
$

Vậy chiều dài quãng đường xe đi được xấp xỉ $187,5 k m$.
]
#baitoan[
  *1.22.* Tốc độ chạy của một vận động viên được ghi nhận trong bảng sau, với $t$ là thời điểm kể từ thời điểm xuất phát và $v$ là tốc độ tại thời điểm $t$.

#align(center)[
  #table(
    columns: 8,
    align: center,
    stroke: 0.7pt,
    inset: (x: 10pt, y: 5pt),
    [$t$ $(s)$], [$0$], [$0,5$], [$1$], [$1,5$], [$2$], [$2,5$], [$3$],
    [$v$ $(m/s)$], [$0$], [$2$], [$4$], [$5,5$], [$6$], [$6$], [$5,8$],
  )
]


Hãy ước tính chiều dài quãng đường mà vận động viên đã chạy được.
]
#loigiai[
   Khoảng thời gian giữa hai lần đo liên tiếp là $Delta t = 0,5 s$. Ta ước lượng vận tốc trung bình trên mỗi khoảng bằng trung bình cộng của vận tốc tại hai đầu khoảng. Do đó quãng đường vận động viên chạy được xấp xỉ

$
s approx 0,5 [
  (0 + 2)/2
  + (2 + 4)/2
  + (4 + 5,5)/2
  + (5,5 + 6)/2
  + (6 + 6)/2
  + (6 + 5,8)/2
].
$

Suy ra

$
s approx 0,5 (1 + 3 + 4,75 + 5,75 + 6 + 5,9)
= 13,2 m.
$

Vậy chiều dài quãng đường mà vận động viên đã chạy được xấp xỉ
$13,2 m.$


]
#baitoan[
  *1.23.* Tốc độ hấp thụ $C O_2$ của cây trong quá trình quang hợp $P$ được cho bằng cách đo thể tích $C O_2$ được hấp thụ trên một đơn vị diện tích bề mặt lá cây trong một đơn vị thời gian (tính bằng phút). Số liệu thu thập được như sau:

#align(center)[
  #table(
    columns: 6,
    align: center,
    stroke: 0.7pt,
    inset: (x: 10pt, y: 5pt),
    [$t$],    [$0$],   [$10$],  [$40$],  [$55$],  [$60$],
    [$P(t)$], [$4,1$], [$6,2$], [$7,7$], [$8,4$], [$9,2$],
  )
]

Hãy ước tính tổng lượng $C O_2$ được cây hấp thụ trong khoảng thời gian này, đo bằng thể tích $C O_2$ hấp thụ trên một đơn vị diện tích bề mặt lá cây.
]
#loigiai[
  Ta ước tính tổng lượng $C O_2$ hấp thụ bằng quy tắc hình thang. Vì các khoảng thời gian không bằng nhau nên ta tính riêng trên từng khoảng:
$
integral_0^60 P(t) dif t
approx
10 dot (4,1 + 6,2)/2
+ 30 dot (6,2 + 7,7)/2
+ 15 dot (7,7 + 8,4)/2
+ 5 dot (8,4 + 9,2)/2.
$
Do đó
$
integral_0^60 P(t) dif t
approx 51,5 + 208,5 + 120,75 + 44
= 424,75.
$
Vậy tổng lượng $C O_2$ mà cây hấp thụ trong khoảng thời gian từ $0$ đến $60$ phút xấp xỉ $424,75$

]
#baitoan[
 *1.24* Cho hàm số $f$ liên tục trên $[1, 9]$. Biết thông tin giá trị hàm $f$ như bảng sau.

#align(center)[
  #table(
    columns: 6,
    align: center,
    stroke: 0.7pt,
    inset: (x: 10pt, y: 5pt),
    [$x$],    [$1$],   [$3$], [$5$],   [$7$], [$9$],
    [$f(x)$], [$0,5$], [$1$], [$1,5$], [$2$], [$2,5$],
  )
]

Tìm xấp xỉ tích phân $integral_1^9 f(x) dif x$ bằng cách tính tổng Riemann tương ứng với phân hoạch đoạn $[1, 9]$ thành 4 đoạn với điểm mẫu (điểm đại diện) là điểm bên trái của mỗi đoạn con.
]
#loigiai[
  Phân hoạch đoạn $[1, 9]$ thành 4 đoạn con là $[1,3]$, $[3,5]$, $[5,7]$, $[7,9]$. Mỗi đoạn có độ dài

$
Delta x = 2.
$

Vì điểm mẫu là điểm bên trái của mỗi đoạn con nên các điểm mẫu lần lượt là $1,3,5,7$. Do đó tổng Riemann là

$
integral_1^9 f(x) dif x
approx
f(1) dot 2 + f(3) dot 2 + f(5) dot 2 + f(7) dot 2.
$

Từ bảng số liệu, ta có $f(1)=0,5$, $f(3)=1$, $f(5)=1,5$, $f(7)=2$, nên

$
integral_1^9 f(x) dif x
approx
2(0,5 + 1 + 1,5 + 2)
= 10.
$

Vậy

$
integral_1^9 f(x) dif x approx 10.
$
]
#baitoan[
  *1.25.* Một hồ nước hình chữ nhật kích thước $4 m times 8 m$ có độ sâu không đều. Người ta đo được chiều sâu tại một số điểm trên hồ trong bảng sau. Ví dụ trong bảng này độ sâu tại điểm cách bờ trái $5 m$ và bờ trên $1 m$ là $4,6 m$. Hãy ước lượng thể tích nước trong hồ.

#align(center)[
  #table(
    columns: 5,
    align: center,
    stroke: 0.7pt,
    inset: (x: 10pt, y: 5pt),
    [Vị trí], [$1$], [$3$], [$5$], [$7$],
    [$1$], [$3,1$], [$4,5$], [$4,6$], [$4,0$],
    [$3$], [$3,7$], [$4,1$], [$4,5$], [$4,4$],
  )
]
]
#loigiai[
 Chia mặt hồ kích thước $4 m times 8 m$ thành $2 times 4 = 8$ hình chữ nhật bằng nhau. Mỗi hình có kích thước $2 m times 2 m$, nên diện tích là

$
Delta A = 2 dot 2 = 4 m^2.
$

Các số liệu trong bảng chính là độ sâu tại điểm mẫu của mỗi hình chữ nhật. Do đó, dùng tổng Riemann để ước lượng thể tích nước trong hồ:

$
V approx 4(3,1 + 4,5 + 4,6 + 4,0 + 3,7 + 4,1 + 4,5 + 4,4).
$

Suy ra

$
V approx 4 dot 32,9 = 131,6 m^3.
$

Vậy thể tích nước trong hồ xấp xỉ

$
131,6 m^3.
$
]
#baitoan[
  *1.26.* Về địa lý, một tỉnh nọ có thể được xem như một hình chữ nhật kích thước dài $110 k m$ rộng $55 k m$. Tỉnh được chia đều thành $3 times 2$ vùng hình chữ nhật, chiều dài được chia làm 3, chiều rộng được chia làm 2, ở mỗi vùng có một trạm quan trắc khí tượng. Dưới đây là dữ liệu lượng mưa đo được ở các trạm này trong năm 2020:

#align(center)[
  #table(
    columns: 3,
    align: center,
    stroke: 0.7pt,
    inset: (x: 10pt, y: 5pt),
    [$1293,4$], [$1230,8$], [$1938,2$],
    [$3196,5$], [$2690,1$], [$1452,0$],
  )
]

Lượng mưa có đơn vị là $m m$, theo đó $1 m m$ nghĩa là $1 m m$ chiều cao trên $1 m^2$ diện tích. Hãy ước tính tổng lượng nước mưa trên cả tỉnh trong năm.
]
#loigiai[
  Diện tích của cả tỉnh là

$
S = 110 dot 55 = 6050 k m^2.
$

Tỉnh được chia đều thành $3 times 2 = 6$ vùng nên diện tích mỗi vùng là

$
Delta S = 6050/6 k m^2 = 6050/6 dot 10^6 m^2.
$

Đổi lượng mưa từ $m m$ sang $m$, ta có tổng lượng nước mưa trên toàn tỉnh được ước tính bằng tổng Riemann

$
V approx Delta S dot 10^(-3)
(1293,4 + 1230,8 + 1938,2 + 3196,5 + 2690,1 + 1452,0).
$

Vì

$
1293,4 + 1230,8 + 1938,2 + 3196,5 + 2690,1 + 1452,0
= 11801,
$

nên

$
V approx
6050/6 dot 10^6 dot 10^(-3) dot 11801
= 11899341666,67 m^3.
$

Vậy tổng lượng nước mưa trên cả tỉnh trong năm xấp xỉ

$
V approx 1,19 dot 10^10 m^3.
$

]
#pagebreak()
#baitoan[
  *1.27.* Cho $f(x,y) = x$ trên hình chữ nhật $0 <= x <= 1$, $0 <= y <= 1$. Hãy tính các tổng dưới, tổng trên, và tổng Riemann ứng với điểm đại diện là điểm giữa của các hình chữ nhật con ứng với các phép chia sau.

(a) Chia đôi chiều $x$, tức là dùng các điểm chia $x_0 = 0$, $x_1 = 1/2$, $x_2 = 1$, $y_0 = 0$, $y_1 = 1$.

(b) Chia đều chiều $x$ làm 4 đoạn cùng chiều dài, tức là dùng các điểm chia $x_0 = 0$, $x_1 = 1/4$, $x_2 = 1/2$, $x_3 = 3/4$, $x_4 = 1$, $y_0 = 0$, $y_1 = 1$.
]
#loigiai[
  Vì $f(x,y) = x$ tăng theo $x$ và không phụ thuộc vào $y$, nên trên mỗi hình chữ nhật con, giá trị nhỏ nhất của $f$ đạt tại cạnh trái, giá trị lớn nhất đạt tại cạnh phải.

*(a)* Chia $[0,1] times [0,1]$ thành hai hình chữ nhật
$R_1 = [0,1/2] times [0,1]$ và $R_2 = [1/2,1] times [0,1]$. Mỗi hình có diện tích

$
Delta A = 1/2.
$

Trên $R_1$, ta có $m_1 = 0$, $M_1 = 1/2$; trên $R_2$, ta có $m_2 = 1/2$, $M_2 = 1$. Do đó tổng dưới là

$
L = 0 dot 1/2 + 1/2 dot 1/2 = 1/4,
$

và tổng trên là

$
U = 1/2 dot 1/2 + 1 dot 1/2 = 3/4.
$

Các điểm giữa có hoành độ lần lượt là $1/4$ và $3/4$, nên tổng Riemann là

$
S = [f(1/4,1/2) + f(3/4,1/2)] dot 1/2
= (1/4 + 3/4) dot 1/2
= 1/2.
$

Vậy

$
L = 1/4, quad U = 3/4, quad S = 1/2.
$

*(b)* Chia chiều $x$ thành 4 đoạn bằng nhau, mỗi hình chữ nhật con có diện tích

$
Delta A = 1/4.
$

Giá trị nhỏ nhất của $f$ trên các hình chữ nhật con lần lượt là $0$, $1/4$, $1/2$, $3/4$. Do đó

$
L = (0 + 1/4 + 1/2 + 3/4) dot 1/4 = 3/8.
$

Giá trị lớn nhất lần lượt là $1/4$, $1/2$, $3/4$, $1$, nên

$
U = (1/4 + 1/2 + 3/4 + 1) dot 1/4 = 5/8.
$

Các điểm giữa có hoành độ $1/8$, $3/8$, $5/8$, $7/8$, nên

$
S = (1/8 + 3/8 + 5/8 + 7/8) dot 1/4 = 1/2.
$

Vậy

$
L = 3/8, quad U = 5/8, quad S = 1/2.
$
]
#pagebreak()
#baitoan[
  *1.28.* Cho $f(x,y) = x y$ trên hình chữ nhật $1 <= x <= 3$, $1 <= y <= 4$. Hãy tính các tổng dưới, tổng trên, và tổng Riemann ứng với điểm đại diện là điểm giữa của các hình chữ nhật con ứng với các phép chia sau.

(a) Chia đôi chiều $x$, tức là dùng các điểm chia $x_0 = 1$, $x_1 = 2$, $x_2 = 3$, $y_0 = 1$, $y_1 = 4$.

(b) Dùng các điểm chia $x_0 = 1$, $x_1 = 2$, $x_2 = 3$, $y_0 = 1$, $y_1 = 3$, $y_2 = 4$.

(c) Chia đều thành các hình vuông có cạnh chiều dài $1$.
]
#loigiai[
Vì $f(x,y) = x y$ với $x > 0$, $y > 0$ nên $f$ tăng theo cả $x$ và $y$. Vì vậy, trên mỗi hình chữ nhật con, giá trị nhỏ nhất đạt tại góc dưới bên trái và giá trị lớn nhất đạt tại góc trên bên phải.

*(a)* Ta có hai hình chữ nhật con $[1,2] times [1,4]$ và $[2,3] times [1,4]$, mỗi hình có diện tích $Delta A = 3$. Do đó tổng dưới và tổng trên lần lượt là

$
L = (1 dot 1) dot 3 + (2 dot 1) dot 3 = 9,
$

$
U = (2 dot 4) dot 3 + (3 dot 4) dot 3 = 60.
$

Các điểm giữa là $(3/2,5/2)$ và $(5/2,5/2)$, nên tổng Riemann là

$
S = [f(3/2,5/2) + f(5/2,5/2)] dot 3
= (15/4 + 25/4) dot 3
= 30.
$

Vậy

$
L = 9, quad U = 60, quad S = 30.
$

*(b)* Ta có bốn hình chữ nhật con. Hai hình nằm trong dải $1 <= y <= 3$ có diện tích $2$, hai hình nằm trong dải $3 <= y <= 4$ có diện tích $1$. Do đó

$
L = 1 dot 2 + 2 dot 2 + 3 dot 1 + 6 dot 1 = 15,
$

$
U = 6 dot 2 + 9 dot 2 + 8 dot 1 + 12 dot 1 = 50.
$

Các điểm giữa lần lượt là $(3/2,2)$, $(5/2,2)$, $(3/2,7/2)$ và $(5/2,7/2)$. Vì vậy

$
S = 3 dot 2 + 5 dot 2 + 21/4 dot 1 + 35/4 dot 1
= 30.
$

Vậy

$
L = 15, quad U = 50, quad S = 30.
$

*(c)* Chia đều thành các hình vuông cạnh $1$, ta được $2 times 3 = 6$ hình vuông, mỗi hình có diện tích $Delta A = 1$.

Tổng dưới là

$
L = (1 + 2)(1 + 2 + 3) = 18.
$

Tổng trên là

$
U = (2 + 3)(2 + 3 + 4) = 45.
$

Các hoành độ điểm giữa là $3/2, 5/2$, các tung độ điểm giữa là $3/2, 5/2, 7/2$. Do đó tổng Riemann là

$
S = (3/2 + 5/2)(3/2 + 5/2 + 7/2)
= 30.
$

Vậy

$
L = 18, quad U = 45, quad S = 30.
$
  
]
#pagebreak()
#baitoan[
  *1.29.* Cho $f(x,y) = x/y$ trên hình chữ nhật $1 <= x <= 3$, $1 <= y <= 4$. Hãy tính các tổng dưới, tổng trên, và tổng Riemann ứng với điểm đại diện là điểm giữa của các hình chữ nhật con ứng với các phép chia sau.

(a) Chia đôi chiều $x$, tức là dùng các điểm chia $x_0 = 1$, $x_1 = 2$, $x_2 = 3$, $y_0 = 1$, $y_1 = 4$.

(b) Dùng các điểm chia $x_0 = 1$, $x_1 = 2$, $x_2 = 3$, $y_0 = 1$, $y_1 = 3$, $y_2 = 4$.

(c) Chia đều thành các hình vuông có cạnh chiều dài $1$.
]
#loigiai[
  Vì $f(x,y) = x/y$ với $x > 0$, $y > 0$ nên $f$ tăng theo $x$ và giảm theo $y$. Vì vậy, trên mỗi hình chữ nhật con, giá trị nhỏ nhất đạt tại góc trên bên trái và giá trị lớn nhất đạt tại góc dưới bên phải.

*(a)* Ta có hai hình chữ nhật con $[1,2] times [1,4]$ và $[2,3] times [1,4]$, mỗi hình có diện tích $Delta A = 3$. Do đó

$
L = (1/4 + 2/4) dot 3 = 9/4,
$

$
U = (2 + 3) dot 3 = 15.
$

Các điểm giữa là $(3/2,5/2)$ và $(5/2,5/2)$, nên tổng Riemann là

$
S = [f(3/2,5/2) + f(5/2,5/2)] dot 3
= (3/5 + 1) dot 3
= 24/5.
$

Vậy $L = 9/4, quad U = 15, quad S = 24/5$.

*(b)* Ta có bốn hình chữ nhật con. Hai hình ứng với $1 <= y <= 3$ có diện tích $2$, hai hình ứng với $3 <= y <= 4$ có diện tích $1$. Do đó

$
L = (1/3) dot 2 + (2/3) dot 2 + 1/4 + 1/2
= 11/4,
$

$
U = 2 dot 2 + 3 dot 2 + 2/3 + 1
= 35/3.
$

Các điểm giữa lần lượt là $(3/2,2)$, $(5/2,2)$, $(3/2,7/2)$ và $(5/2,7/2)$, nên

$
S = (3/4) dot 2 + (5/4) dot 2 + 3/7 + 5/7
= 36/7.
$

Vậy $L = 11/4, quad U = 35/3, quad S = 36/7$.

*(c)* Chia đều thành các hình vuông cạnh $1$, ta được $2 times 3 = 6$ hình vuông, mỗi hình có diện tích $Delta A = 1$. Tổng dưới là

$
L = (1 + 2)(1/2 + 1/3 + 1/4)
= 13/4.
$

Tổng trên là

$
U = (2 + 3)(1 + 1/2 + 1/3)
= 55/6.
$

Các hoành độ điểm giữa là $3/2, 5/2$, các tung độ điểm giữa là $3/2, 5/2, 7/2$. Do đó

$
S
= (3/2 + 5/2)(2/3 + 2/5 + 2/7)
= 568/105.
$

Vậy $L = 13/4, quad U = 55/6, quad S = 568/105$.
]
#baitoan[
  *1.30.* Hãy cho một ước lượng cho giá trị của tích phân (nghĩa là cho biết tích phân có thể có giá trị trong khoảng số thực nào)

$
integral.double_([0,1] times [1,2]) e^(x^2 y^3) dif x dif y.
$
]
#loigiai[
  Trên hình chữ nhật $R = [0,1] times [1,2]$, ta có

$
0 <= x^2 <= 1, quad 1 <= y^3 <= 8,
$

suy ra

$
0 <= x^2 y^3 <= 8.
$

Do hàm mũ tăng nên

$
1 <= e^(x^2 y^3) <= e^8.
$

Diện tích của $R$ là

$
A(R) = (1 - 0)(2 - 1) = 1.
$

Vì vậy

$
1 dot A(R)
<= integral.double_([0,1] times [1,2]) e^(x^2 y^3) dif x dif y
<= e^8 dot A(R).
$

Do đó

$
1 <= integral.double_([0,1] times [1,2]) e^(x^2 y^3) dif x dif y <= e^8
$

Vậy giá trị của tích phân nằm trong khoảng $[1,e^8]$.
]
#baitoan[
  *1.31.* Điều sau đây là đúng hay sai, giải thích:

$
integral.double_([0,1] times [1,4]) (x^2 + sqrt(y)) sin(x y^2) dif A = 10.
$
]
#loigiai[
  Mệnh đề đã cho là *sai*. Trên hình chữ nhật $R = [0,1] times [1,4]$, ta có

$
0 <= x^2 <= 1, quad 1 <= sqrt(y) <= 2,
$

nên

$
x^2 + sqrt(y) <= 3.
$

Mặt khác, $sin(x y^2) <= 1$, do đó

$
(x^2 + sqrt(y)) sin(x y^2) <= 3.
$

Diện tích của miền $R$ là

$
A(R) = (1 - 0)(4 - 1) = 3.
$

Theo tính chất ước lượng của tích phân,

$
integral.double_R (x^2 + sqrt(y)) sin(x y^2) dif A
<= 3 A(R)
= 9.
$
]
#baitoan[
  *1.32.* Giả sử hàm $f(x,y) = x$ khả tích trên hình chữ nhật $0 <= x <= 1$, $0 <= y <= 1$, hãy tính tích phân của $f$ bằng cách lấy giới hạn của tổng Riemann ứng với phép chia đều với điểm lấy mẫu là điểm giữa.
]
#loigiai[
   Chia đều mỗi đoạn $[0,1]$ trên hai trục $x$ và $y$ thành $n$ đoạn bằng nhau. Khi đó mỗi hình chữ nhật con có diện tích

$
Delta A = 1/n^2.
$

Điểm giữa của hình chữ nhật con thứ $(i,j)$ là

$
(x_i^*, y_j^*) = ((2i-1)/(2n), (2j-1)/(2n)),
quad i,j = 1,2,...,n.
$

Vì $f(x,y)=x$, tổng Riemann tương ứng là

$
S_n
= sum_(i=1)^n sum_(j=1)^n
f((2i-1)/(2n),(2j-1)/(2n)) 1/n^2
= sum_(i=1)^n sum_(j=1)^n
(2i-1)/(2n) 1/n^2.
$

Do biểu thức không phụ thuộc vào $j$ nên

$
S_n
= 1/(2n^3) sum_(i=1)^n sum_(j=1)^n (2i-1)
= 1/(2n^2) sum_(i=1)^n (2i-1).
$

Mà

$
sum_(i=1)^n (2i-1) = n^2,
$

suy ra

$
S_n = 1/2.
$

Do đó

$
integral.double_([0,1] times [0,1]) x dif A
= lim_(n -> infinity) S_n
= 1/2.
$
]
#baitoan[
  *1.33.* Chứng tỏ nếu $P'$ mịn hơn $P$ thì
$U(f,P') <= U(f,P).$
]
#loigiai[
Giả sử $P'$ mịn hơn $P$. Khi đó mỗi hình chữ nhật con $R$ của phân hoạch $P$ được chia thành các hình chữ nhật con $R_1, R_2, ..., R_k$ của phân hoạch $P'$.

Đặt

$
M = sup_(x in R) f(x), quad
M_i = sup_(x in R_i) f(x).
$

Vì $R_i subset R$ nên

$
M_i <= M.
$

Do đó

$
sum_(i=1)^k M_i V(R_i)
<= M sum_(i=1)^k V(R_i)
= M V(R).
$

Như vậy, khi chia nhỏ một hình chữ nhật của $P$, phần đóng góp của nó vào tổng trên không tăng. Cộng bất đẳng thức trên cho tất cả các hình chữ nhật con của $P$, ta được

$
U(f,P') <= U(f,P).
$

Vậy

$
U(f,P') <= U(f,P)).
$
]
#baitoan[
  *1.34.* Hãy cho một ví dụ minh họa rằng xấp xỉ Riemann ứng với một phép chia mịn hơn không nhất thiết tốt hơn.
]
#loigiai[
  Xét hàm $f(x) = x^2$ trên đoạn $[0,1]$. Ta có

$
integral_0^1 x^2 dif x = 1/3.
$

Với phân hoạch $P = {0,1}$, chọn điểm lấy mẫu $xi = 1/sqrt(3)$. Khi đó tổng Riemann là

$
S(P) = f(1/sqrt(3)) dot 1 = 1/3,
$

nên xấp xỉ này đúng bằng giá trị tích phân.

Bây giờ xét phân hoạch mịn hơn $P' = {0,1/2,1}$ và chọn các điểm lấy mẫu là đầu trái của mỗi đoạn con. Khi đó

$
S(P')
= f(0) dot 1/2 + f(1/2) dot 1/2
= 1/8.
$

Do đó

$
|S(P) - 1/3| = 0,
quad
|S(P') - 1/3| = 5/24 > 0.
$

Vậy mặc dù $P'$ mịn hơn $P$, xấp xỉ Riemann ứng với $P'$ lại kém hơn. Điều này cho thấy một phép chia mịn hơn *không nhất thiết* cho xấp xỉ Riemann tốt hơn.
]
#baitoan[
  *1.36.* Hãy chứng tỏ rằng tích phân của một hàm số trên một hình hộp đúng bằng thể tích của hình hộp nhân với giới hạn của giá trị trung bình của hàm số tại các điểm đại diện trong phép chia đều. Cụ thể hơn, lấy phép chia đều mỗi cạnh của hình hộp $I subset RR^n$ thành $m$ khoảng con dài bằng nhau. Trong mỗi hình hộp con $R_i$, $1 <= i <= m^n$, lấy điểm $x_(R_i)$ làm điểm đại diện. Chứng tỏ nếu $f$ khả tích thì

$
integral_I f
= |I| [
  lim_(m -> infinity)
  1/m^n
  sum_(i=1)^(m^n) f(x_(R_i))
].
$
]
#loigiai[
   Chia đều mỗi cạnh của hình hộp $I subset RR^n$ thành $m$ khoảng bằng nhau. Khi đó ta thu được $m^n$ hình hộp con $R_1, R_2, ..., R_(m^n)$ có cùng thể tích. Vì các hình hộp con phủ $I$ và không chồng lấn phần trong nên

$
|R_i| = (|I|)/m^n,
quad i = 1,2,...,m^n.
$

Chọn một điểm đại diện $x_(R_i) in R_i$ trong mỗi hình hộp con. Tổng Riemann tương ứng là

$
sum_(i=1)^(m^n) f(x_(R_i)) |R_i|
= sum_(i=1)^(m^n) f(x_(R_i)) (|I|)/m^n
= |I| 1/m^n sum_(i=1)^(m^n) f(x_(R_i)).
$

Khi $m -> infinity$, độ dài mỗi cạnh của các hình hộp con tiến về $0$, do đó độ mịn của phép chia cũng tiến về $0$. Vì $f$ khả tích trên $I$, mọi tổng Riemann tương ứng hội tụ về tích phân của $f$. Vì vậy

$
integral_I f
= lim_(m -> infinity)
sum_(i=1)^(m^n) f(x_(R_i)) |R_i|
= |I| lim_(m -> infinity)
1/m^n sum_(i=1)^(m^n) f(x_(R_i)).
$

Do đó

$
integral_I f
= |I| [
  lim_(m -> infinity)
  1/m^n
  sum_(i=1)^(m^n) f(x_(R_i))
].
$
]
#loigiai[

  $

  integral_(0)^1 integral_(0)^1(e^y/y) d y d x=
  integral_(0)^1 (integral_(0)^1(e^y/y) d y) d x
  $
]
$D={(x,y) in RR^2, 0<=x<=1,x<=y<=sqrt(x)}$.


= Tuần 2
== Sự khả tích
Xét $f : I -> RR$, với $I$ là hình hộp
#menhde[
  Hàm $f$ bị chặn trên hình hộp $I$ khả tích Darboux khi và chỉ khi, $
  forall epsilon>0, exists P, U(f,p)-L(f,p)<epsilon
  $
   Nói cách khác, hàm bị chặn khả tích Darboux khi và chỉ khi tổng dưới và tổng
trên gần nhau tùy ý.

]
#chungminh[
  
  *(<=)* Ta chỉ ra $(forall epsilon >0,exists P, U(f,p)-L(f,p)<epsilon) => (sup_p L(f,p)=inf_p U(f,p))$.

  Có $0 <= inf_p U(f,p) - sup_p L(f,p)<= U(f,p)-L(f,p)<epsilon$.

  *(=>)* Giả sử $f$ khả tích, khi đó có $P',P''$ sao cho $ L(f,p')> integral_I f-epsilon $ và $U(f,p'') < integral_I+epsilon$. Khi đó, chọn $P=P' union P''$, thì 
  $
  U(f,p)- L(f,p) < 2 epsilon
  $
]

#dinhly[
  *Liên tục thì khả tích.* Một hàm thực liên tục trên một hình hộp thì khả tích Darboux lẫn khả tích Riemann và hai tích phân này bằng nhau.
]

Đây là một điều kiện đủ cho sự khả tích mà ta dùng thường xuyên trong môn này.

#chungminh[
  Chứng minh chủ yếu dựa vào tính liên tục đều của hàm. Ta dùng các kết quả quan trọng sau trong Giải tích 2 (\[TTQ11\] \[TTV\] \[Lan97, tr. 193\]): _Một hàm thực liên tục trên một tập con compắc của $RR^n$ thì liên tục đều._

  Giả sử $f : I -> RR$ là một hàm liên tục trên hình hộp $I$. Khi đó $f$ liên tục đều trên $I$, do đó cho trước $epsilon > 0$, có $delta > 0$ sao cho $norm(x-y) < delta => f(x) - f(y) < epsilon$.

  Lấy một phép chia $P$ của $I$ sao cho khoảng cách giữa hai điểm bất kì trong một hình hộp con là nhỏ hơn $delta$. Điều này thực hiện được nếu chiều dài mỗi cạnh của một hình hộp nhỏ hơn $alpha$ thì chiều dài của một đường chéo của hình hộp đó nhỏ hơn $sqrt(n) alpha$, từ công thức Pythagore.

  Với hai điểm $x, y$ bất kì thuộc về một hình hộp con $R$ thì $f(x) - f(y) < epsilon$, nên $max_(x in R) f(x) - min_(y in R) f(y) < epsilon$. Do đó

  $
    U(f,P) - L(f,P)
    &= sum_R (max_R f - min_R f) |R| \
    &< epsilon sum_R |R| = epsilon |I|.
  $

  Theo Mệnh đề 2.1 hàm $f$ khả tích Darboux và giá trị của tích phân Darboux

  $
    beta = inf_P U(f,P) = sup_P L(f,P)
  $

  thỏa $L(f,P) <= beta <= U(f,P)$ với mọi $P$.

  Mặt khác, tổng Riemann bất kì ứng với phép chia $P$ cũng thỏa

  $
    L(f,P) <= sum_R f(x_R) |R| <= U(f,P).
  $

  Suy ra

  $
    |sum_R f(x_R) |R| - beta|
    <= U(f,P) - L(f,P) < epsilon |I|.
  $

  Ta kết luận $f$ khả tích Riemann và tích phân Riemann của $f$ đúng bằng $beta$. $square$
]
== Sự khả tích của hàm không liên tục

#dinhnghia[
  Tập có thể tích không (Volume 0) là tập có thể được phủ bằng hữu hạn hình hộp có tổng thể tích nhỏ tùy ý. Một tập con $C$ của $RR^n$ có thể tích không trong $RR^n$ nếu với mọi $epsilon >0$ có một họ hữu hạn các hình hộp n-chiều $(U_1,U_2,dots,U_m)$ sao cho $C subset union_(i=1)^m U_i$ và $sum_(i=1)^m abs(U_i)<epsilon$
]
#dinhly[
  Hàm bị chặn và liên tục trên hình hộp trừ một tập có thể tích không thì khả tích.
]
#menhde[
  Đồ thị của một hàm khả tích trên một hình hộp trong $RR^n$ có thể tích không trong $RR^(n+1)$.
]
#dinhly[
  *(Liên tục trừ ra trên tập có thể tích không thì khả tích)*. Một hàm
thực trên một hình hộp nếu bị chặn và liên tục trừ ra trên một tập có thể tích không
thì khả tích.
]
#dinhly[
  Cho $f$ và $g$ là hàm bị chặn trên một hình hộp $I$ và $f=g$ trên $I$ trừ một tập có thể tích không. Ta có $f$ khả tích trên $I$ khi và chỉ khi $g$ khả tích trên $I$, và $integral_I f=integral_I$ g.
  
*  Vậy giá trị của một hàm bị chặn trên một tập có thể tích không không ảnh
hưởng đến tích phân.*

]
#vidu[
  Hàm có khả tích không?
  $
  f(x,y)=cases(4 quad 0<=x<=1"," 0<=y<=1, 5 quad 1<x<=2 "," 0<=y<=1)
  $
]
#chungminh[
  Với tùy ý $x,y in D$, ta có
  $
  4<=f(x,y)<=5
  $
  Do đó, $f$ bị chặn trên $D$. Hơn nữa tại các điểm $x<1$ và $x>1$, thì $f(x,y)$ là hằng số nên xác định và liên tục.

  Tại $x=1$,xét điểm $y_0$ với $y_0 in [0,1]$, có
  $
  lim_(x -> 1^(-)) f(x,y_0)=4 != lim_(x -> 1^(+)) f(x,y_0)=5
  $
  Suy ra, tập các điểm gián đoạn của $f$ là :
  $
  D_f={(1,y),y in [0,1]}
  $
  Ta chứng minh $D_f$ có thể tích Jordan bằng $0$, thật vậy cho trước $epsilon >0$, tìm $(Q_(i)(epsilon))_(1<=i<=m)$ sao cho $D_f subset union_(i=1)^m ( Q_(i)(epsilon))$ và $ sum _(i=1)^m |Q_i(epsilon)| <epsilon $ Chọn $Q_(epsilon)=[1-epsilon/4,1+epsilon/4] times [0,1] $ thì $D_f subset Q_epsilon$ hơn nữa 
  $
  sum_(i=1)^1 |Q_(epsilon)|=V(Q_(epsilon))=epsilon/2 <epsilon
  $
  Do đó, $D_f$ có thể tích Jordan bằng $0$. Theo định lý, ta có $f$ khả tích Riemann trên $D$.
]
== Bài Tập
#baitoan[
  *Bài toán 2.14.* Các hàm sau có khả tích không?

  *a)* $f(x, y) = x, quad 0 <= x <= 1, quad 0 <= y <= 1.$

  *b)* $f(x, y) = x y, quad 0 <= x <= 3, quad 0 <= y <= 2.$

  *c)* $f(x, y) = x/y, quad 1 <= x <= 4, quad 1 <= y <= 3.$
]
#loigiai[

  *a)* Xét $f(x,y)=x$, khi đó $f(x,y)$ xác định trên $D=[0,1] times [0,1]$ , vì $f(x,y)$ xác định trên $D$ và là hàm sơ cấp, do đó $f$ liên tục trên $D$, suy ra $f$ khả tích trên $D$.

  *b)* Xét $f(x,y)=x y$, đặt $g(x,y)=x$ và $h(x,y)=y$, khi đó $f(x,y)=g(x,y) h(x,y)$ tương tự chứng minh trên, ta có $g$ và $h$ đều là hàm liên tục trên $D=[0,3] times [0,2]$, do đó $f$ liên tục trên $[0,3]times [0,2]$ suy ra $f$ khả tích trên D.

  *(c)* Với $y in [1,3]$ thì $f(x,y)=x/y$ xác định trên $D=[1,4] times [1,3]$ , hơn nữa $f(x,y)=x/y$ là hàm sơ cấp nên $f(x,y)$ liên tục trên $D$ suy ra $f$ khả tích trên D.
]
#baitoan[
  *Bài toán 2.15.* Các hàm sau có khả tích không? Nếu hàm khả tích thì hãy tính tích phân của hàm nếu có thể.

  *a)*
  $
    f(x) = cases(
      x & quad 0 <= x <= 1 ", " x != 1/2,
      10^9 & quad x = 1/2.
    )
  $

  *b)*
  $
    f(x, y) = cases(
      x/y & quad  0 <= x <= 1 ", " 0 < y <= 1,
      0 &quad 0 <= x <= 1 ", " y = 0.
    )
  $

  *c)*
  $
    f(x, y) = cases(
      4 & quad  0 <= x <= 1 ", " 0 <= y <= 1 ", " (x, y) != (1/2, 1/2),
      5 & quad (x, y) = (1/2, 1/2).
    )
  $

  *d)*
  $
    f(x, y) = cases(
      2 & quad  0 <= x <= 1 ", " 0 <= y <= 1 ", " y != x,
      x & quad  0 <= x <= 1 ", " 0 <= y <= 1 ", " y = x.
    )
  $

  *e)*
  $
    f(x, y) = cases(
      3 & quad 0 <= x <= 1 ", " 0 <= y <= 1 ", " y != x^2,
      x^2 &  quad 0 <= x <= 1 ", " 0 <= y <= 1 ", " y = x^2.
    )
  $
]
#loigiai[

  *a)* 
  Với mỗi $x != 1/2$ thì $f$ liên tục tại $x$, hơn nữa tại $x=1/2$, có 
  $
  lim_(x -> 1/2)=1/2 != f(1/2)=10^9
  $
  Do đó, $f$ không liên tục tại $x=1/2$ suy ra $D_f={1/2}$, do $D_f$ có thể tích không và $f$ bị chặn trên $[0,1]$ nên $f$ khả tích trên $[0,1]$ theo tiêu chuẩn Riemann.
 $ 
 integral_(0)^1 f(x)d x=integral_0^1 x d x =1/2
  $
  
  *b)* Trên $D=[0,1] times [0,1]$ thì $f(x,y)= x/y$ không bị chặn, do với $x>0$ và $y -> 0^(+)$, thì $f(x,y) -> infinity$. Do đó, $f$ không khả tích trên $D$.

  
  *c)* Có $D=[0,1] times[0,1]$, khi đó
  $
  4<=f(x,y)<=5
  
  $Do đó, $f$ bị chặn trên $D$. Với mỗi $(x,y) != (1/2,1/2)$ thì $f(x,y)=4$, do đó $f$ liên tục tại $(x,y) in D backslash (1/2,1/2)$, tại $(x,y)=(1/2,1/2)$ thì $f(x,y)=5$ nhưng $
  lim_((x,y)->(1/2,1/2)) f(x,y)=4 != 5=f(1/2,1/2)
  $
  Do đó, $f$ không liên tục tại $(x,y)=(1/2,1/2)$, suy ra $D_f={(1/2,1/2)}$ có $D_f$ có thể tích không trên $RR^2$, suy ra $f$ khả tích trên $D$.Hơn nữa, 
  $
   integral.double_D f(x,y)d A= integral.double_D 4 d A=4 V(D)=4
  $

  *d)*
]
#baitoan[
  *Bài toán 2.16.*
  Kiểm mệnh đề :
  
  Hội của hai tập có thể tích không trong $RR^n$ là một tập có thể tích không.
]
#loigiai[

  Giả sử $A$ và $B$ là hai tập có thể tích không trong $RR^n$, ta chứng minh $A union B$ có thể tích không.

  Có $V(A)=0 <=> forall epsilon_a>0 quad exists (A_i)_(1<=i<=m) : A subset union_(i=1)^m A_i$ và $sum_(i=1)^m |A_i| <epsilon_a$.

  Có $V(B)=0 <=> forall epsilon_n >0 quad exists (B_i)_(1<=i<=k) : B subset union_(i=1)^k B_i$ và $sum_(i=1)^k |B_i| <epsilon_b$.

  Xét $epsilon_a=epsilon_b=epsilon/2$, và chọn $(Q_i)_(1<=i<=m+k)=(A_i )_(1<=i<=m) union(B_i)_(1<=i<=k)$ thì $A union B subset union_(i=1)^(m+k) Q_i$, hơn nữa
  $
  sum_(i=1)^(m+k )|Q_i|=sum_(i=1)^m |A_i| + sum_(j=1)^k |B_j| < epsilon/2 +epsilon/2 =epsilon
  $
]
#baitoan[
  *Bài toán 2.17.* Chứng tỏ biên của một hình hộp $n$-chiều có thể tích $n$-chiều không.
]
#loigiai[

Giả sử $I subset RR^n$ là hình hộp $n$-chiều, với
$
  I = product_(i=1)^n [a_i, b_i], quad a_i <= b_i.
$

Ký hiệu $partial I$ là biên của hình hộp $I$. Ta cần chứng minh $V(partial I) = 0$.

Theo định nghĩa, ta cần chứng minh rằng với mọi $epsilon > 0$, tồn tại hữu hạn hình hộp $Q_1, dots, Q_m$ sao cho
$
  partial I subset union.big_(k=1)^m Q_k, quad
  sum_(k=1)^m |Q_k| < epsilon.
$

*Bước 1. Biểu diễn biên của hình hộp.*

Biên của hình hộp $I$ là hợp của $2n$ mặt:
$
  partial I = union.big_(i=1)^n (F_i^- union F_i^+),
$
trong đó
$
  F_i^- = brace.l x in I : x_i = a_i brace.r,
$
$
  F_i^+ = brace.l x in I : x_i = b_i brace.r.
$

*Bước 2. Xây dựng các hình hộp phủ biên.*

Cho trước $epsilon > 0$. Với $delta > 0$, xét các hình hộp
$
  Q_i^- =
  product_(j=1)^(i-1) [a_j - delta, b_j + delta]
  times [a_i - delta, a_i + delta]
  times product_(j=i+1)^n [a_j - delta, b_j + delta],
$
và
$
  Q_i^+ =
  product_(j=1)^(i-1) [a_j - delta, b_j + delta]
  times [b_i - delta, b_i + delta]
  times product_(j=i+1)^n [a_j - delta, b_j + delta].
$

Khi đó $F_i^- subset Q_i^-$ và $F_i^+ subset Q_i^+$, suy ra
$
  partial I subset union.big_(i=1)^n (Q_i^- union Q_i^+).
$

*Bước 3. Ước lượng tổng thể tích.*

Đặt
$
  L = max_(1 <= j <= n) (b_j - a_j).
$

Với $0 < delta < 1$, ta có
$
  |Q_i^-| = |Q_i^+|
  = 2 delta product_(j != i) (b_j - a_j + 2 delta)
  <= 2 delta (L+2)^(n-1).
$

Do đó
$
  sum_(i=1)^n (|Q_i^-| + |Q_i^+|)
  <= 4n delta (L+2)^(n-1).
$

Chọn
$
  0 < delta < min(1, epsilon/(4n(L+2)^(n-1))).
$

Khi đó
$
  sum_(i=1)^n (|Q_i^-| + |Q_i^+|)
  < epsilon.
$

Vì $epsilon > 0$ tùy ý, theo định nghĩa tập có thể tích không, suy ra
$
  V(partial I) = 0.
$

]
#baitoan[
  *Bài toán 2.18.* Trong Bài tập 2.19 ta có thể dùng các tính chất sau của $sup$ và $inf$. Cho $A$ là một tập con của $RR$, khác rỗng, bị chặn. Với số thực $c$, kí hiệu
  $
    c A = \{c x | x in A\}, quad
    -A = (-1) A = \{-x | x in A\}.
  $
  Hãy kiểm:

  *a)* Nếu $c > 0$ thì
  $
    sup c A = c sup A, quad inf c A = c inf A.
  $

  *b)*
  $
    sup (-A) = -inf A, quad inf (-A) = -sup A.
  $

  *c)* Nếu $c < 0$ thì
  $
    sup c A = c inf A, quad inf c A = c sup A.
  $
]
#loigiai[
  
  *a)*
  
  Vì $A$ bị chặn trên $RR$, do đó theo tiên đề về tính đầy đủ của $RR$, luôn tìm được $M=sup A$. Ta chứng minh $c A$ bị chặn trên, thật vậy, với tùy ý $x in c A$, khi đó $exists y in A$ sao cho $x=c y$, và $y <= M$ suy ra $x <= c M$, vậy $c M$ là một chặn trên của $c A$, do đó tồn tại $sup c A$. Ta chứng minh $c M$ là chặn trên nhỏ nhất của $c A$, thật vậy giả sử $M'$ là một chặn trên khác của $c A$, khi đó với mỗi $x in c A$ ta đều có $x <= M'$, vì $x in c A$, nên $y <= M'/c$ vì $sup (A)$ là chặn trên của $A$, do đó $sup(A)<=M'/c$ => $c sup A=M <= M'$. Vậy $c sup A=sup (c A)$.

  Tương tự với ý tưởng $inf(c A)=c inf (A)$.Vì $A$ bị chặn nên theo tiên đề về tính đầy đủ của $RR$, ta luôn tìm được $N=inf(A)$, khi đó với mỗi $x in c A$, $exists y in A$ sao cho $x= c y$, vì $y >= inf(A)$, do đó $x >= c inf(A)$, suy ra $c inf(A)$ là một chặn dưới của $c A$, ta chứng minh $c inf(A)$ là chặn trên nhỏ nhất của $c A$, thật vậy lấy $N'$ là một chặn trên khác của $c A$, khi đó $c x >= N' => x >= N'/c$, điều này đúng với mỗi $x in A$, nên $inf (A)>= N'/c => c inf (A)>= N'$ suy ra $c inf A=inf(c A)$.

  *b)* 
  
  \Vì $A$ bị chặn nên $-A$ cũng bị chặn, do đó $exists sup (-A) in RR$, đặt $sup (-A)=M$, khi đó với mỗi $x in A$, ta đều có $x>= inf (A) $, suy ra $-x <= - inf(A)$, và $-x in -A$, khi đó $-inf(A)$ là một chặn trên của $-A$, ta chứng minh $-inf(A)$ là chặn trên nhỏ nhất, thật vậy gọi $M'$ là một chặn trên khác của $-A$, khi đó $-x  <= M' <=> x >= -M'$ vì $x in A  $, do đó $inf (A)>= -M' => -inf(A)<= M'$, do đó $-inf(A)=sup(-A)$.

  Tương tự, ta chứng minh được $-A$ bị chặn, do đó tồn tại $inf(-A)$, với mỗi $x in A$, ta đều có $ x<= sup A$ suy ra $-x >= - sup(A)$, do đó $-sup(A)$ là một chặn dưới của $-A$, khi đó với $N$ là một chặn dưới khác của $-A$, ta chứng minh $-sup A>= N$. Thật vậy , với mỗi $-x in -A$, ta đều có $-x >=N <=> x <=-N$ vì điều này đúng với mỗi $x in A$, nên $sup(A)>= -N => -sup (A)<= N$, Vậy
  $
  inf(-A)=-sup(A)
  $

  *c)* Giả sử $c<0$, ta chứng minh $sup c A=c inf A$. Thật vậy , với tùy ý $x in A$, ta đều có $x>=inf A <=> c x<= c inf(A)$. Gọi $N$ là một chặn trên khác của $c A$, khi đó với mỗi $x in A$, ta đều có $c x<= N <=> x >= N/c$, do đó, $inf(A)>= N/c <=>$
  
]
#baitoan[
  *Bài toán 2.19.* Chứng minh Mệnh đề 1.19 bằng cách dùng tổng dưới, tổng trên, Bài tập 2.18, và Mệnh đề 2.1.

   *Mệnh đề 1.19.* Nếu $f$ và $g$ khả tích trên hình hộp $I$ thì:

  *a)* $f + g$ khả tích và
  $
    integral_I (f + g) = integral_I f + integral_I g.
  $

  *b)* Với mọi số thực $c$ thì $c f$ khả tích và
  $
    integral_I c f = c integral_I f.
  $

  *c)* Nếu $f <= g$ thì
  $
    integral_I f <= integral_I g.
  $

  *Mệnh đề 2.1.* Hàm $f$ bị chặn trên hình hộp $I$ là khả tích Darboux nếu và chỉ nếu với mọi $epsilon > 0$ có phép chia $P$ của $I$ sao cho
  $
    U(f, P) - L(f, P) < epsilon.
  $
]

#baitoan[
  *Bài toán 2.20.* $ast$ Cho $f: [0, 1] arrow RR$,
  $
    f(x) = cases(
      1 & quad x in QQ,
      0 & quad x in.not QQ.
    )
  $

  Hàm $f$ liên tục ở đâu? Hàm $f$ có khả tích không?
]
#loigiai[

  Với $x_0 in QQ$, do tính trù mật của $Q$ trong $RR$, khi đó luôn có dãy số vô tỉ $x_n -> x$ hơn nữa $f(x_n)=0 !=f(x_0)=1$, do đó $f $ không liên tục trên $Q$, hơn nữa với $x $
]
= Tuần 3 
== Tích phân trên tập tổng quát
Ta xét các tập con của $RR^n$, để ngắn gọn hơn ta dùng từ *miền* để chỉ các tập như vậy. *Ta chỉ xét tích phân trên tập bị chặn.*
Để xây dựng tích phân trên một miền bị chặn bất kì ta dùng một ý rất đơn giản: Cho hàm giá trị $0$ *bên ngoài miền xác định ban đầu*, và lấy tích phân hàm mới này trên một hình chữ nhật chứa miền xác định ban đầu. *Như thế phần bên ngoài miền xác định ban đầu chỉ đóng góp giá trị $0$ vào giá trị của tích phân, nên giá trị của tích phân thực sự đại diện cho tổng giá trị của hàm đã cho trên miền xác định ban đầu.* Một cách trực quan, phần thể tích của khối bên dưới đồ thị bên ngoài miền xác định ban đầu có độ cao $0$ nên có thể tích bằng $0$, do đó thể tích của khối mà đáy là hình chữ nhật vẫn chỉ bằng thể tích của khối ban đầu.

#align(center)[
  #box(width: 6cm, height: 5.7cm)[
    #place(top + left)[
      #rect(
        width: 8cm,
        height: 5.7cm,
        fill: rgb("#D3FAF1"),
        stroke: 0.8pt + gray,
      )
    ]

    #place(top + left, dx: 1.55cm, dy: 0.75cm)[
      #ellipse(
        width: 5.5cm,
        height: 4.1cm,
        fill: rgb("#DFE1D5"),
        stroke: 0.8pt + gray,
      )
    ]

    #place(top + left, dx: 6.95cm, dy: 0.2cm)[$I$]
    #place(top + left, dx: 5.1cm, dy: 1.35cm)[$D$]
  ]
]
#dinhnghia[
 Cho $D subset RR^n$ là một tập bị chặn, và cho $f: D -> RR$. Vì $D$ bị chặn nên có hình hộp $I$ chứa $D$. Mở rộng $f$ lên hình hộp $I$ thành hàm $F: I -> RR$ xác định bởi

  $ F(x) = cases(
    f(x) "," & x in D,
    0 "," & x in I without D.
  ) $

  _Ta nói $f$ là_ #text(fill: rgb("#9467FF"))[_khả tích_] _trên $D$ nếu $F$ khả tích trên $I$, và khi đó_ #text(fill: rgb("#9467FF"))[_tích phân_] _của $f$ trên $D$ được định nghĩa là tích phân của $F$ trên $I$:_

  #align(center)[
    #rect(
      fill: rgb("#E1EEF0"),
      inset: (x: 12pt, y: 6pt),
    )[
      $ integral_D f = integral_I F. $
    ]
  ]
]
#bode[
  _Tích phân $integral_D f$ không phụ thuộc vào cách chọn hình hộp $I$._
  
  Bổ đề này nói rằng định nghĩa tích phân nói trên chỉ phụ thuộc đầu vào
là hàm $f$ , như thế người ta thường nói rằng tích phân “được định nghĩa tốt”.
]
#dinhnghia[
  *Định nghĩa thể tích thông qua tích phân* 
  
  _Cho $D$ là một tập con bị chặn của $RR^n$._ #text(fill: rgb("#9467FF"))[_Thể tích_] _$n$-chiều của $D$ được định nghĩa là tích phân của hàm $1$ trên $D$:_

  #align(center)[
    #rect(
      fill: rgb("#E1EEF0"),
      inset: (x: 12pt, y: 6pt),
    )[
      $ |D| = integral_D 1. $
    ]
  ]
]

Để tích phân của $f$ trên $D$ được định nghĩa thì $F$ phải bị chặn trên $I$, do đó #text(fill: rgb("#E86B25"))[_$f$ phải bị chặn trên $D$._]
== Sự khả tích và sự có thể tích

Có thể giải thích chi tiết hơn định nghĩa thể tích trên như sau. Đặt miền bị chặn $D$ vào trong một hình hộp $I$. Xét hàm có giá trị bằng $1$ trên $D$ và bằng $0$ ngoài $D$. Hàm này thường được gọi là #text(fill: rgb("#9467FF"))[hàm đặc trưng]#super[2] của $D$, kí hiệu là $chi_D$:

$ chi_D(x) = cases(
  1 "," & x in D,
  0 "," & x in RR^n without D.
) $

Định nghĩa 3.3 của thể tích và Định nghĩa 3.1 của tích phân cho

$ |D| = integral_I chi_D. $

Xét một phép chia $P$ của $I$. Ta có $U(chi_D, P) = sum_R (sup_R chi_D) |R| = sum_(R ∩ D ≠ ∅) |R|$, bằng tổng thể tích của các hình chữ nhật con của $I$ mà có phần chung khác rỗng với $D$, chính là một chặn trên "thể tích" của $D$. Trong khi đó $L(chi_D, P) = sum_R (inf_R chi_D) |R| = sum_(R ⊂ D) |R|$, bằng tổng thể tích của các hình chữ nhật con của $I$ mà nằm trong $D$, chính là một chặn dưới "thể tích" của $D$. Xem minh họa ở Hình 3.4.

Tập $D$ có thể tích khi và chỉ khi chặn dưới và chặn trên của thể tích có thể gần nhau tùy ý, và số thực duy nhất nằm giữa được gọi là thể tích của $D$. Hai chặn này có thể gần nhau tùy ý khi các hình hộp phủ phần biên có tổng thể tích nhỏ tùy ý.

Lý luận trên gợi ý một trả lời cho câu hỏi "hình nào có thể tích?":
#dinhly[
  Một tập con bị chặn của $RR^n$ có thể tích $n-$chiều nếu và chỉ nếu biên của nó có thể tích không.
]
#dinhly[
 Nếu tập con $D$ của $RR^n$ có thể tích, hàm $f$ xác định và bị chặn trên $D$, và tập điểm không liên tục của $f$ có thể tích không, thì $f$ khả tích trên $D$. ]
#menhde[
  *Đồ thị của hàm khả tích có thể tích không*. Đồ thị của một hàm khả tích trên tập con bị chặn của $RR^n$ thì có thể tích không trong $RR^(n+1)$
]
#pagebreak()
#vidu[
   *(Khối đa diện có thể tích)*. Khối đa diện là phần không gian $RR^3$
bao bởi hữu hạn mặt, mỗi mặt là một miền bao bởi một đa giác trong một mặt
phẳng. Biên của khối đa diện là hội của các mặt này. Mỗi mặt biên $S$ bao bởi
một đa giác trong một mặt phẳng $P$ trong $RR^(3)$
có hình chiếu vuông góc xuống
một trong ba mặt phẳng tọa độ là một đa giác $T$, do đó $S$ là đồ thị của một
hàm liên tục (hàm tuyến tính xác định mặt phẳng $P$) xác định trên tập bị chặn
$T$, do đó $S$ có thể tích không trong $RR^3$
, theo Mệnh đề $3.7$, suy ra khối đa diện
có thể tích, theo Định lý $3.4$.
]
  #align(center)[#image("Tong Hop Hinh/hinh-3-17.png", width: 70%)]
  
  #align(center)[_Hình 3.8 Những hình có thể tích._]
== Tính chất của tích phân
#menhde[
  Nếu $f$ và $g$ khả tích trên $D$ thì:

  + $f + g$ khả tích và
    $ integral_D (f + g) = integral_D f + integral_D g $.

  + Với mọi số thực $c$ thì $c f$ khả tích và
    $ integral_D c f = c integral_D f $.

  + Nếu $f <= g$ thì
    $ integral_D f <= integral_D g $.
]
#chungminh[
  Ta chứng minh phần (a).

  Lấy một hình hộp $I$ chứa $D$ và gọi $F$ và $G$ lần lượt là mở rộng của $f$ và $g$ lên $I$, bằng $0$ ngoài $D$. Theo định nghĩa của tích phân, do $f$ và $g$ khả tích trên $D$ nên $F$ và $G$ khả tích trên $I$. Theo tính chất của tích phân trên hình hộp, Mệnh đề 1.19, ta có $(F + G)$ khả tích trên $I$ và

  $ integral_I (F + G) = integral_I F + integral_I G. $

  Vì $(F + G)$ là mở rộng của $(f + g)$ lên $I$ bằng $0$ ngoài $D$ nên $(F + G)$ khả tích trên $I$ dẫn tới $(f + g)$ khả tích trên $D$. Hơn nữa,

  $ integral_D (f + g) = integral_I (F + G) = integral_I F + integral_I G = integral_D f + integral_D g. $
]

#vidu[
  Giả sử $A subset RR^n$, $A$ có thể tích. Cho $c in RR$. Ta có

  $ integral_A c = integral_A c dot 1 = c integral_A 1 = c |A|. $
]
#vidu[
  $
  integral.double_(x^2+y^2 <=1)
 x y dif x dif y=  $
]

Tương tự như kết quả cho hình hộp, Định lý 2.13, ta có:

#menhde[
  Cho $D$ là một tập con bị chặn của $RR^n$, $f$ và $g$ bị chặn trên $D$, và $f = g$ trên $D$ trừ một tập có thể tích không, thì $f$ khả tích khi và chỉ khi $g$ khả tích, và khi đó

  $ integral_D f = integral_D g. $
]

Nói tóm tắt, *giá trị của một hàm bị chặn trên một tập thể tích không không ảnh hưởng đến tích phân.*

#chungminh[
  Lấy một hình hộp $I$ chứa $D$. Gọi $F$ và $G$ là các mở rộng của $f$ và $g$ lên $I$, bằng không ngoài $D$. Khi đó $F(x) = G(x)$ trên $I$ trừ ra một tập thể tích không.

  Nếu $f$ khả tích trên $D$ thì $F$ khả tích trên $I$, dẫn tới $G$ khả tích trên $I$ theo Định lý 2.13, nên $g$ khả tích trên $D$, và

  $ integral_D f = integral_I F = integral_I G = integral_D g. $
]

#menhde[
  *Hệ quả  (thêm bớt một tập thể tích không không ảnh hưởng tới tích phân).*

  Cho $D$ là tập con bị chặn của $RR^n$, $C$ là tập con của $D$ có thể tích không, và $f$ bị chặn trên $D$. Ta có $f$ khả tích trên $D$ khi và chỉ khi $f$ khả tích trên $D without C$, và khi đó

  $ integral_D f = integral_(D without C) f. $
]

#chungminh[
  Đặt hàm $g$ xác định trên $D$ sao cho $g(x) = f(x)$ trên $D without C$ và $g(x) = 0$ trên $C$.

  Do Mệnh đề 3.15 hàm $g$ cũng khả tích trên $D$ và

  $ integral_D g = integral_D f. $

  Mặt khác từ định nghĩa của tích phân trên tập tổng quát, đặt $D$ vào trong một hình hộp $I$, ta rút ra

  $ integral_D g = integral_I g chi_D = integral_I g chi_(D without C) = integral_(D without C) g = integral_(D without C) f. $
]
#vidu[
  Tích phân sau có tồn tại hay không, nếu có thì bằng bao nhiêu?

  $ integral_([0,1)) x dif x. $

  Dùng Hệ quả $3.11$, do tập ${1}$ có chiều dài không nên

  $ integral_([0,1)) x dif x = integral_([0,1]) x dif x = integral_0^1 x dif x = 1/2 x^2 |_(x=0)^(x=1) = 1/2. $
]

#vidu[
  Hàm sau có khả tích không, nếu có thì tích phân bằng bao nhiêu?

  $ f(x,y) = -1, quad 0 <= x < 1, quad 0 <= y <= 2. $

  Tập ${1} times [0,2]$, một đoạn thẳng trong mặt phẳng, có diện tích không, nên theo Hệ quả 3.16:

  $ integral.double_([0,1) times [0,2]) -1 dif x dif y = integral.double_([0,1] times [0,2]) -1 dif x dif y = -1 dot |[0,1] times [0,2]| = -2. $
]

#menhde[
  *Hệ quả *

  Cho $D_1$ và $D_2$ là hai tập con bị chặn của $RR^n$. Giả sử $D_1 inter D_2$ có thể tích không. Nếu $f$ khả tích trên $D_1$ và trên $D_2$ thì $f$ khả tích trên $D_1 union D_2$, và

  $ integral_(D_1 union D_2) f = integral_(D_1) f + integral_(D_2) f. $
]

Kết quả này cho phép ta #text(fill: rgb("#D97706"))[*tính tích phân trên một miền bằng cách chia miền đó thành những miền đơn giản hơn.*]
#vidu[
  Trong trường hợp riêng, ta có công thức quen thuộc cho hàm một biến.
  $
  integral_(a)^b f(x)dif x= integral_(a)^c f(x) dif x + integral_(c)^b f(x) dif x
  $
]
#chungminh[
  Đặt $f_1$ xác định trên $D = D_1 union D_2$ sao cho $f_1 = f$ trên $D_1$ và $f_1 = 0$ trên $D without D_1$. Tương tự, đặt $f_2$ xác định trên $D$ sao cho $f_2 = f$ trên $D_2$ và $f_2 = 0$ trên $D without D_2$.

  Vì $f$ khả tích trên $D_1$ nên từ định nghĩa tích phân trên tập tổng quát ta có ngay $f_1$ khả tích trên $D$ và

  $ integral_D f_1 = integral_(D_1) f. $

  Tương tự $f_2$ khả tích trên $D$ và

  $ integral_D f_2 = integral_(D_2) f. $

  Ta có $f_1 + f_2 = f$ trên $D without (D_1 inter D_2)$. Vì $f_1 + f_2$ khả tích trên $D$ và $D_1 inter D_2$ có thể tích không nên do Mệnh đề 3.15 hàm $f$ khả tích trên $D$ và do Mệnh đề $3.8$:

  $ integral_D f = integral_D (f_1 + f_2) = integral_D f_1 + integral_D f_2 = integral_(D_1) f + integral_(D_2) f. $
]
#vidu[
  Hàm sau có khả tích không, nếu có thì tích phân bằng bao nhiêu?

  $ f(x,y) = cases(
    2 quad &"," 0 <= x <= 1"," quad 0 <= y <= 1,
    3  quad &"," 1 < x <= 2"," quad 0 <= y <= 1.
  ) $

  Theo Hệ quả 3.11 ta có

  $ integral.double_([0,2] times [0,1]) f
  = integral.double_([0,1] times [0,1]) f
  + integral.double_((1,2] times [0,1]) f
  = integral.double_([0,1] times [0,1]) 2
  + integral.double_((1,2] times [0,1]) 3. $

  Vì tập ${1} times [0,1]$ có diện tích không nên theo Hệ quả 3.16 ta có

  $ integral.double_((1,2] times [0,1]) 3
  = integral.double_([1,2] times [0,1]) 3. $

  Vậy $f$ khả tích và tích phân của $f$ bằng $2 + 3 = 5$.
]

Trong Mệnh đề 3.14 trên lấy $f = 1$ ta có kết quả:

#menhde[
  *Tính cộng của thể tích.*

  Nếu $D_1$ và $D_2$ có thể tích và $D_1 inter D_2$ có thể tích không thì

  $ |D_1 union D_2| = |D_1| + |D_2|. $
]

Đặc biệt, tính cộng của thể tích là đúng khi hai tập là rời nhau và có thể tích. Đây là một tính chất nền tảng của thể tích mà ta hướng tới từ đầu. Khi tính diện tích một hình ta vẫn thường chia hình đó thành những hình con đơn giản hơn bằng những đoạn thẳng hay đoạn cong (vốn có diện tích không), rồi cộng các diện tích của các hình con đó lại với nhau, như Hình 3.19.

#align(center)[
  #image("Tong Hop Hinh/hinh-3-19.png", width: 72%)
]

#block[
  Hình 3.19: Diện tích miền bao bởi tứ giác $A B C D$ bằng diện tích miền bao bởi tam giác $A B D$ cộng diện tích miền bao bởi tam giác $B C D$. Hai tam giác này có phần giao là cạnh $B D$, tuy khác rỗng nhưng có diện tích không.
]

#chungminh[
  *Bổ đề 3.2.*

  Giả sử $F_1$ là mở rộng của $f$ lên $I_1 supset D$ bằng không ngoài $D$, và $F_2$ là mở rộng của $f$ lên $I_2 supset D$ bằng không ngoài $D$. Ta cần chứng minh điều sau: nếu $F_1$ khả tích trên $I_1$ thì $F_2$ khả tích trên $I_2$, và

  $ integral_(I_1) F_1 = integral_(I_2) F_2. $

  Đặt $I_3 = I_1 inter I_2$ thì $I_3$ là một hình hộp con của $I_1$, và $F_3$ là mở rộng của $f$ lên $I_3 supset D$ bằng không ngoài $D$. Ta chứng minh điều sau là đủ: $F_1$ khả tích trên $I_1$ khi và chỉ khi $F_3$ khả tích trên $I_3$, và

  $ integral_(I_1) F_1 = integral_(I_3) F_3. $

  Ý của lý luận trong nhiều trường hợp khá đơn giản, người học có thể làm thử. Lý luận tổng quát dưới đây dài hơn vì cần tránh phức tạp có thể xảy ra bên biên của hình hộp.

  Đặt hàm $F_1'$ xác định trên $I_1$ sao cho $F_1'$ trùng với $F_1$ trừ ra trên biên của $I_3$, nơi mà $F_1'$ được định nghĩa là bằng không. Vì $F_1'$ chỉ khác $F_1$ trên một tập có thể tích không nên theo Định lý 2.13, $F_1'$ khả tích khi và chỉ khi $F_1$ khả tích, và

  $ integral_(I_1) F_1' = integral_(I_1) F_1. $

  #align(center)[
    #image("Tong Hop Hinh/hinh-bo-de-3-2.png", width: 55%)
  ]

  Một phép chia bất kì $P$ của $I_3$ sinh ra một phép chia $P'$ của $I_1$ bằng cách thêm vào tọa độ các đỉnh của $I_1$. Nếu một hình hộp con $R$ ứng với $P'$ không chứa trong $I_3$ thì $sup_R F_1' = inf_R F_1' = 0$ (dùng giả thiết $F_1'$ bằng không trên biên của $I_3$). Điều này dẫn tới

  $ U(F_1', P') = U(F_1'|_(I_3), P) $

  và

  $ L(F_1', P') = L(F_1'|_(I_3), P). $

  Do đó nếu $F_1'|_(I_3)$ khả tích thì $F_1'$ khả tích và

  $ integral_(I_1) F_1' = integral_(I_3) F_1'|_(I_3). $

  Ngược lại, một phép chia bất kì $P'$ của $I_1$ sinh ra một phép chia $P''$ của $I_1$ mịn hơn $P'$ bằng cách thêm vào tọa độ các đỉnh của $I_3$. Thu hẹp $P''$ lên $I_3$ ta được một phép chia $P$ của $I_3$. Giống như đoạn vừa rồi,

  $ U(F_1', P'') = U(F_1'|_(I_3), P) $

  và

  $ L(F_1', P'') = L(F_1'|_(I_3), P). $

  Do đó nếu $F_1'$ khả tích thì $F_1'|_(I_3)$ khả tích và

  $ integral_(I_3) F_1'|_(I_3) = integral_(I_1) F_1'. $

  Cuối cùng, hàm $F_1'|_(I_3)$ là thu hẹp của $F_1'$ xuống $I_3$, chỉ có thể khác $F_3$ trên biên của $I_3$, một tập có thể tích không. Do đó $F_1'|_(I_3)$ khả tích khi và chỉ khi $F_3$ khả tích, và

  $ integral_(I_3) F_1'|_(I_3) = integral_(I_3) F_3. $
]
== Bài Tập
#baitoan[
  *Bài toán 3.20.* Hãy giải thích tại sao khoảng $(a,b)$ có chiều dài bằng $(b-a)$.
]
#loigiai[
  *Nếu chấp nhận kết quả của độ đo lebesgue.*
  
  Ta có nhận xét : $(a,b)=[a,b]backslash{a} union {b}$. Và $[a,b] inter {a} union {b}=emptyset$. Do đó, theo tính cộng tính hữu hạn của độ đo lebesgue. Thì
  $
  m(a,b)=m([a,b])-m({a})-m({b})=b-a
  $

  *Hàm đặc trưng* Xét : $ 
  f: [a,b] -> RR quad f(x)= cases(1 quad x in (a,b),0  quad x in.not (a,b))
  $
  Do đó, $D_f={a,b}$, và $V(D_f)=0$ lại có $f$ bị chặn nên suy ra $f$ khả tích trên $D=[a,b]$, và xét $g(x)=f(x)$ trên $D backslash D_f$ và $g(x)=1$ trên $D_f$. Khi đó 
  $
  V(a,b)=integral_a^b 1_D x=b-a
  $
]
#baitoan[
  *Bài toán 3.21.* Hãy giải thích tại sao miền phẳng bên dưới parabola $y=1-x^2$ bên trên đoạn $-1 <= x <= 1$ có diện tích.
]
#loigiai[
   #align(center)[
    #image("Tong Hop Hinh/hinh--btap3.png", width: 55%)
  ]
]
#align(center)[_Đồ thị hàm số : $y=1-x^2$_]

#loigiai[
  Xét miền phẳng
  $
    D = \{(x,y) in RR^2 : -1 <= x <= 1, 0 <= y <= 1-x^2\}.
  $

  Ta chứng minh $D$ có diện tích Jordan bằng cách chỉ ra rằng biên $partial D$ có thể tích bằng không.
  Vì, đồ thị hàm số của $y=1-x^2=D_f={(x,y) in RR^2 : y=1-x^2}union{(x,y)in RR^2:-1<=x<=1}$ hơn nữa, $D subset [-1,1]times[0,1]$, bị chặn nên có thể tích không trong $RR^2$, do $f=1-x^2$ liên tục trên $[-1,1]$, và $g=0$ liên tục trên $[-1,1]$.

  *Cách Tiếp Cận Khác* :

  
  *Bước 1. Chứng minh $partial D$ có thể tích bằng không.*

  Ta có $partial D = Gamma_1 union Gamma_2$, trong đó
  $
    Gamma_1 = \{(x,0) : -1 <= x <= 1\},
  $
  $
    Gamma_2 = \{(x,1-x^2) : -1 <= x <= 1\}.
  $

  Cho $epsilon > 0$ bất kỳ.

  *a)* Đối với $Gamma_1$, xét hình chữ nhật
  $
    Q_0 = [-1,1] times [0,epsilon/4].
  $

  Khi đó $Gamma_1 subset.eq Q_0$ và
  $
    V(Q_0) = 2 dot epsilon/4 = epsilon/2.
  $

  *b)* Đối với $Gamma_2$, đặt $f(x) = 1-x^2$. Chia đoạn $[-1,1]$ thành $n$ đoạn con bằng nhau, mỗi đoạn có độ dài $Delta x = 2/n$.

  Với mọi $x,y in [-1,1]$, ta có
  $
    |f(x)-f(y)|
    = |x-y| |x+y|
    <= 2|x-y|.
  $

  Do đó, độ dao động của $f$ trên mỗi đoạn con không vượt quá
  $
    2 Delta x = 4/n.
  $

  Suy ra phần đồ thị nằm trên mỗi đoạn con có thể được phủ bởi một hình chữ nhật $Q_i$ có diện tích thỏa mãn
  $
    V(Q_i) <= 2/n dot 4/n = 8/n^2.
  $

  Vì thế,
  $
    sum_(i=1)^n V(Q_i)
    <= n dot 8/n^2
    = 8/n.
  $

  Chọn $n$ đủ lớn sao cho $8/n < epsilon/2$. Khi đó,
  $
    partial D subset.eq union.big_(i=0)^n Q_i,
  $
  và
  $
    sum_(i=0)^n V(Q_i)
    <= epsilon/2 + 8/n
    < epsilon.
  $

  Vì $epsilon > 0$ tùy ý, theo định nghĩa tập có thể tích bằng không, suy ra
  $
    V(partial D) = 0.
  $

  *Bước 2. Sử dụng hàm đặc trưng.*

  Đặt $I = [-1,1] times [0,1]$ và xét hàm đặc trưng
  $
    chi_D(x,y) =
    cases(
      1 & "nếu" (x,y) in D,
      0 & "nếu" (x,y) in.not D.
    )
  $

  Ta có $chi_D$ bị chặn trên $I$ và tập điểm gián đoạn của $chi_D$ trên $I$ thỏa mãn
  $
    D_(chi_D) subset.eq partial D.
  $

  Vì $V(partial D) = 0$, nên $D_(chi_D)$ cũng có thể tích bằng không.

  Theo tiêu chuẩn khả tích Riemann, $chi_D$ khả tích trên $I$.

  Do đó, theo định nghĩa thể tích Jordan thông qua hàm đặc trưng,
  $
    V(D) = integral_I chi_D(x,y) dif x dif y
  $
  tồn tại.

  Vậy miền phẳng $D$ có diện tích Jordan.

  *Nếu cần tính diện tích*, ta có
  $
    V(D)
    &= integral_(-1)^1 (
      integral_0^(1-x^2) 1 dif y
    ) dif x \
    &= integral_(-1)^1 (1-x^2) dif x \
    &= [x - x^3/3]_(-1)^1 \
    &= 4/3.
  $
]

#baitoan[
  *Bài toán 3.22.* Hãy giải thích tại sao miền phẳng bao bởi một đường elip (một hình bầu dục) là có diện tích
  $ x^2/a^2 + y^2/b^2 <= 1 $
]

#loigiai[
  Xét miền phẳng
  $
    D = \{(x,y) in RR^2 :
    x^2/a^2 + y^2/b^2 <= 1\},
    quad a,b > 0.
  $

  Ta có $D subset.eq [-a,a] times [-b,b]$, nên $D$ bị chặn.

  Mặt khác, biên của $D$ là
  $
    partial D = Gamma_1 union Gamma_2,
  $
  trong đó
  $
    Gamma_1 = \{(x, b sqrt(1-x^2/a^2)) :
    x in [-a,a]\},
  $
  $
    Gamma_2 = \{(x, -b sqrt(1-x^2/a^2)) :
    x in [-a,a]\}.
  $

  Xét hai hàm số
  $
    f_1(x) = b sqrt(1-x^2/a^2),
  $
  $
    f_2(x) = -b sqrt(1-x^2/a^2).
  $

  Vì $f_1,f_2$ liên tục trên đoạn compact $[-a,a]$, nên đồ thị của chúng có thể tích Jordan bằng không. Do đó,
  $
    V(Gamma_1) = V(Gamma_2) = 0.
  $

  Vì hợp hữu hạn các tập có thể tích bằng không cũng có thể tích bằng không, suy ra
  $
    V(partial D) = 0.
  $

  Mà $D$ bị chặn, nên theo tiêu chuẩn Jordan, $D$ có diện tích Jordan.
]


#baitoan[
  *Bài toán 3.23.* Hãy giải thích tại sao khối tứ diện với 4 đỉnh $(0,0,0)$, $(1,0,0)$, $(0,1,0)$, $(0,0,1)$ là có thể tích.
]

#loigiai[
  Xét khối tứ diện
  $
    D = \{(x,y,z) in RR^3 :
      x >= 0, y >= 0, z >= 0,
      x+y+z <= 1\}.
  $

  Ta có $D subset.eq [0,1]^3$, nên $D$ bị chặn.

  Biên $partial D$ gồm bốn mặt tam giác nằm trong các mặt phẳng
  $
    x=0, quad y=0, quad z=0,
    quad z=1-x-y.
  $

  Mỗi mặt tam giác là tập con của đồ thị một hàm liên tục trên $[0,1]^2$, nên có thể tích Jordan bằng không trong $RR^3$.

  Vì hợp hữu hạn các tập có thể tích bằng không cũng có thể tích bằng không, suy ra
  $
    V(partial D)=0.
  $

  Do $D$ bị chặn, theo tiêu chuẩn Jordan, $D$ có thể tích Jordan.
]



#baitoan[
  *Bài toán 3.24.* Hãy giải thích tại sao khối chóp đáy là hình chữ nhật ở Hình 3.25 là có thể tích.

  #align(center)[#image("Tong Hop Hinh/hinh-3-25.png", width: 30%)]

  #align(center)[_Hình 3.25: Khối chóp đáy là một hình chữ nhật, còn gọi là khối kim tự tháp._]
]
#loigiai[
  Xét khối chóp
  $
    D = \{(x,y,z) in RR^3 :
    -1 <= x,y <= 1,
    0 <= z <= 1-max(|x|,|y|)\}.
  $

  Ta có $D subset.eq [-1,1]^2 times [0,1]$, nên $D$ bị chặn.

  Đặt
  $
    f(x,y)=1-max(|x|,|y|).
  $

  Vì $f$ liên tục trên hình vuông compact $[-1,1]^2$, nên đồ thị của $f$ có thể tích Jordan bằng không trong $RR^3$.

  Mặt khác, biên của $D$ được biểu diễn bởi
  $
    partial D = Gamma_1 union Gamma_2,
  $
  trong đó
  $
    Gamma_1 = \{(x,y,0) :
      (x,y) in [-1,1]^2\},
  $
  $
    Gamma_2 = \{(x,y,f(x,y)) :
      (x,y) in [-1,1]^2\}.
  $

  Vì $Gamma_1$ là đồ thị của hàm hằng $0$ và $Gamma_2$ là đồ thị của hàm liên tục $f$, nên
  $
    V(Gamma_1)=V(Gamma_2)=0.
  $

  Do đó,
  $
    V(partial D)=0.
  $

  Vì $D$ bị chặn và biên của $D$ có thể tích bằng không, nên theo tiêu chuẩn Jordan, $D$ có thể tích Jordan.
]
#baitoan[
  *Bài toán 3.26.* Hãy giải thích tại sao khối lăng trụ đáy là một hình chữ nhật ở Hình 3.27, là có thể tích.

  #align(center)[#image("Tong Hop Hinh/hinh-3-27.png", width: 30%)]

  #align(center)[_Hình 3.27: Khối lăng trụ đáy là một hình chữ nhật._]
]

#loigiai[
  Xét khối lăng trụ
  $
    D = { (x,y,z) in RR^3 :
    -1 <= x <= 1, 0 <= z <= 1,
    -1 + z/2 <= y <= 1 - z/2 }.
  $

  Ta chứng minh $D$ có thể tích Jordan bằng cách chỉ ra rằng $D$ bị chặn và biên $partial D$ có thể tích bằng không.

  *Bước 1. Chứng minh $D$ bị chặn.*

  Ta có
  $
    D subset.eq [-1,1] times [-1,1] times [0,1].
  $
  Do đó $D$ bị chặn trong $RR^3$.

  *Bước 2. Chứng minh $partial D$ có thể tích bằng không.*

  Nhận thấy biên $partial D$ gồm sáu mặt:
  $
    T_1 &: z = 0, \
    T_2 &: z = 1, \
    T_3 &: x = -1, \
    T_4 &: x = 1, \
    T_5 &: y = -1 + z/2, \
    T_6 &: y = 1 - z/2.
  $
  Trong đó, mỗi phương trình chỉ xét trên phần mặt giới hạn của khối lăng trụ.

  Vì mỗi mặt $T_i$ đều nằm trong đồ thị của một hàm liên tục trên một hình chữ nhật compact trong $RR^2$, nên theo định lý về thể tích không của đồ thị hàm liên tục, ta có
  $
    V(T_i) = 0, quad forall i = 1, dots, 6.
  $

  Mặt khác,
  $
    partial D = union_(i=1)^6 T_i.
  $

  Do hợp hữu hạn của các tập có thể tích không cũng có thể tích không, suy ra
  $
    V(partial D) = 0.
  $

  Vậy, vì $D$ bị chặn và $partial D$ có thể tích không nên $D$ có thể tích Jordan.

  Hơn nữa, thể tích của khối được tính bởi
  $
    V(D)
    &= integral_0^1 2(2-z) dif z \
    &= 2 [2z - z^2/2]_0^1 \
    &= 3.
  $
]


#baitoan[
  *Bài toán 3.28.* Hàm sau có khả tích không, nếu có thì tích phân bằng bao nhiêu?

  *a)* $
  f(x,y) = 4, quad 0 < x < 1, quad 0 <= y < 2.
  $

  *b)*
  $ f(x,y) = cases(
    2 & quad 0 <= x <= 1 ", " 0 <= y <= 1,
    -2 & quad 1 < x <= 3 ", " 0 <= y <= 1.
  ) $

  *c)*
  $ f(x,y) = cases(
    3 &quad 0 <= x <= 1 ", " 0 <= y <= 1,
    4 &quad 0 <= x <= 1 ", " 1 < y <= 2,
    5 &quad 1 < x <= 2 ", " 0 <= y <= 2.
  ) $
]
#loigiai[
  Xét miền
  $
    D = (0,1) times [0,2).
  $

  Vì $D$ bị chặn và biên $partial D$ gồm bốn đoạn thẳng có diện tích bằng không, nên $D$ có diện tích Jordan.

  Mặt khác, $f(x,y)=4$ là hàm hằng, do đó liên tục và bị chặn trên $D$. Suy ra $f$ khả tích Riemann trên $D$.

  Ta có
  $
    integral.double_D f(x,y) dif x dif y
    &= 4 S(D) \
    &= 4 dot 1 dot 2 \
    &= 8.
  $


*b)*

  Xét miền
  $
    D = [0,3] times [0,1].
  $

  Vì $D$ là hình chữ nhật nên có diện tích Jordan.

  Mặt khác, $f$ bị chặn trên $D$ và tập hợp các điểm gián đoạn của $f$ là
  $
    E = { (1,y) in RR^2 : 0 <= y <= 1 }.
  $

  Vì $E$ là một đoạn thẳng nên có diện tích bằng không. Theo tiêu chuẩn Lebesgue về tính khả tích Riemann, suy ra $f$ khả tích Riemann trên $D$.

  Đặt
  $
    D_1 &= [0,1] times [0,1], \
    D_2 &= [1,3] times [0,1].
  $

  Nhận thấy $D = D_1 union D_2$ và hai miền chỉ giao nhau trên một đoạn thẳng có diện tích không. Giá trị của $f$ trên đoạn thẳng này không ảnh hưởng đến tích phân.

  Do đó,
  $
    integral.double_D f(x,y) dif x dif y
    &= 2 S(D_1) - 2 S(D_2) \
    &= 2 dot 1 - 2 dot 2 \
    &= -2.
  $

*c)*


  Xét miền
  $
    D = [0,2] times [0,2].
  $

  Vì $D$ là hình chữ nhật nên có diện tích Jordan.

  Mặt khác, $f$ bị chặn trên $D$ và tập hợp các điểm gián đoạn của $f$ là
  $
    E = E_1 union E_2,
  $
  trong đó
  $
    E_1 &= { (1,y) in RR^2 : 0 <= y <= 2 }, \
    E_2 &= { (x,1) in RR^2 : 0 <= x <= 1 }.
  $

  Vì $E_1, E_2$ đều là các đoạn thẳng nên có diện tích bằng không. Do đó, $E$ cũng có diện tích bằng không.

  Theo tiêu chuẩn Lebesgue về tính khả tích Riemann, suy ra $f$ khả tích Riemann trên $D$.

  Chia miền $D$ thành ba hình chữ nhật
  $
    D_1 &= [0,1] times [0,1], \
    D_2 &= [0,1] times [1,2], \
    D_3 &= [1,2] times [0,2].
  $

  Các miền trên chỉ giao nhau tại những đoạn thẳng có diện tích không. Do đó,
  $
    integral.double_D f(x,y) dif x dif y
    &= 3 S(D_1) + 4 S(D_2) + 5 S(D_3) \
    &= 3 dot 1 + 4 dot 1 + 5 dot 2 \
    &= 17.
  $
]
#baitoan[
  *Bài toán 3.29.* Ở Ví dụ 3.7 ta đã giải thích được miền bao bởi hình tròn có diện tích. Ta có thể gọi số $pi$ là diện tích của miền bao bởi hình tròn bán kính $1$ (xem Ví dụ 4.12 ở phần sau). Từ đó ta có một cách đơn giản trực quan để ước lượng số $pi$ bằng diện tích, từ ý ở Hình 3.4. Ta đếm số hình vuông nằm trong hình tròn từ đó có một chặn dưới, và đếm số hình vuông tối thiểu để phủ miền bao bởi hình tròn, từ đó có một chặn trên, xem Hình 3.30.

  Ví dụ ở hình bên trái của Hình 3.30, với phép chia trong hình, có 4 hình vuông bên trong miền bao bởi hình tròn, và cần 16 hình vuông để phủ miền bao bởi hình tròn, do đó ta có chặn

  $ 4 times (0,5 times 0,5) = 1 <= pi <= 16 times (0,5 times 0,5) = 4. $

  #align(center)[#image("Tong Hop Hinh/hinh-3-30.png", width: 65%)]

  #align(center)[_Hình 3.30: Ước lượng số $pi$ bằng diện tích._]

  Nếu ta lấy phép chia mịn hơn thì đánh giá tốt hơn. Hãy cải thiện đánh giá cho số $pi$ bằng cách dùng phép chia ở hình bên phải của Hình 3.30.
]

#baitoan[
  *Bài toán 3.31.* Chứng minh :

  Nếu $f$ và $g$ khả tích trên $D$
  
  *(i)* $f+g$ khả tích và
  $
  integral_D (f+g)= integral_D f+ integral_D g
  $
  *(ii)* $forall c in RR$ thì $c f$ khả tích và $integral_D c f=c integral_D f$.

  *(iii)* Nếu $f<=g$ thì $integral_D f<=integral_D g$.
]
#loigiai[
  *a)*
  
  Lấy hình hộp $I subset RR^n$ và $D subset I$, khi đó đặt $
  F(x)&=cases(f(x) : x in D, 0 : x in.not D)\
  G(x)&=cases(g(x): x in D,0 : x in.not D)
  $
  Khi đó, do $f$ và $g$ khả tích trên $D$, nên $F$ và $G$ khả tích trên $I$. Và $
  integral_I (F+G)= integral_I F+ integral_I G
  $
  Mặt khác, theo định cách đặt $F$ và $G$, thì $F$ và $G$ là mở rộng của $f$ và $g$ , nên $(F+G)$ khả tích trên $I$ dẫn tới $(f+g)$ khả tích trên $D$, và
  $
  integral_I (F+G)=integral_I (f+g)=integral_I f +integral_I g
  $

  *b)*
  Lấy $c in RR$, khi đó lấy hình hộp $I subset RR^n$ sao cho $D subset I$, đặt
  $
  F(x)=cases(f(x) : x in D, 0 : x in.not D) => c F(x)=cases(c f(x) : x in D , 0 : x in.not D)
  $
  Vì $f$ khả tích trên $D$, nên dẫn tới $F$ khả tích trên $I$, hơn nữa $c F$ khả tích trên $I$ nên suy ra $c f$ khả tích trên $D$.Và
  $
  integral_I c F=c integral_I F=integral_D c f=c integral_D f
  $

  *c)*
 Giả sử $f(x) <= g(x)$ với mọi $x in D$.

  Lấy hình hộp $I subset RR^n$ sao cho $D subset I$. Đặt
  $
    F(x) = cases(
      f(x) & : x in D,
      0 & : x in.not D,
    )
  $
  và
  $
    G(x) = cases(
      g(x) & : x in D,
      0 & : x in.not D.
    )
  $

  Vì $f$ và $g$ khả tích trên $D$, nên $F$ và $G$ khả tích trên $I$.

  Mặt khác, với mọi $x in I$, ta có
  $
    F(x) <= G(x).
  $

  Thật vậy, nếu $x in D$ thì $F(x)=f(x) <= g(x)=G(x)$; còn nếu $x$ nằm ngoài $D$ thì $F(x)=G(x)=0$.

  Theo tính chất đơn điệu của tích phân trên hình hộp $I$, ta được
  $
    integral_I F <= integral_I G.
  $

  Theo định nghĩa tích phân trên miền $D$, suy ra
  $
    integral_D f
    = integral_I F
    <= integral_I G
    = integral_D g.
  $

  Vậy
  $
    integral_D f <= integral_D g.
  $
  
]
#baitoan[
  *Bài toán 3.32.* Giả sử $A subset B subset RR^n$, $A$ và $B$ có thể tích. Chứng tỏ $|A| <= |B|$.
]
#loigiai[
  Đặt $C=B backslash A$, khi đó $C inter A= emptyset$ và $C union A= B$. Nên, $V(B)=V(C)+V(A) => V(A)=|A|<=V(B)=|B|$.

  Cách khác, dựa vào tính đơn điệu của tích phân ở mệnh đề trên, ta có, vì $A subset B$ nên $I_(A)(x)<=I_(B)(x), forall x in RR^n$. Khi đó, lấy $I subset RR^n$ sao cho $A subset I$ và $B subset I$.
  $
  V(A) =integral_A 1=integral_I I_A(x) <= = integral_B 1=integral_I I_B(x)=V(B).
  $
]

#baitoan[
  *Bài toán 3.33.* Giả sử $A subset B subset RR^n$, $f$ khả tích trên $A$ và $B$, và $f >= 0$. Chứng tỏ $integral_A f <= integral_B f$.
]
#loigiai[
  Lấy hình hộp $I subset RR^n$ sao cho $B subset I$. Khi đó, đặt
  $
    F(x) = cases(
      f(x) & "nếu" x in A,
      0 & "nếu" x in.not A,
    )
  $
  và
  $
    G(x) = cases(
      f(x) & "nếu" x in B,
      0 & "nếu" x in.not B.
    )
  $

  Vì $f$ khả tích trên $A$ và $B$, nên $F$ và $G$ khả tích trên $I$.

  Ta chứng minh $F(x) <= G(x)$ với mọi $x in I$.

  Thật vậy, xét ba trường hợp:

  - Nếu $x in A$, vì $A subset B$ nên
    $
      F(x) = f(x) = G(x).
    $

  - Nếu $x in B without A$, vì $f(x) >= 0$ nên
    $
      F(x) = 0 <= f(x) = G(x).
    $

  - Nếu $x in I without B$, ta có
    $
      F(x) = G(x) = 0.
    $

  Do đó,
  $
    F(x) <= G(x), quad forall x in I.
  $

  Theo tính đơn điệu của tích phân Riemann trên hình hộp $I$, suy ra
  $
    integral_I F <= integral_I G.
  $

  Mặt khác, theo định nghĩa tích phân trên miền tổng quát, ta có
  $
    integral_A f = integral_I F
    <= integral_I G = integral_B f.
  $

  Vậy
  $
    integral_A f <= integral_B f.
  $
]

#baitoan[
  *Bài toán 3.34.* Cho $f$ khả tích trên $D$. Giả sử $|f|$ khả tích trên $D$, chứng tỏ $|integral_D f| <= integral_D |f|$.

  Xem thêm Bài tập 3.35.
]
#loigiai[
  Ta có bất đẳng thức
  $
    -abs(f(x)) <= f(x) <= abs(f(x)),
    quad forall x in D.
  $

  Vì $f$ và $abs(f)$ khả tích trên $D$, nên theo tính đơn điệu của tích phân Riemann, ta được
  $
    integral_D (-abs(f))
    <= integral_D f
    <= integral_D abs(f).
  $

  Mặt khác, theo tính tuyến tính của tích phân, ta có
  $
    integral_D (-abs(f))
    = - integral_D abs(f).
  $

  Do đó,
  $
    -integral_D abs(f)
    <= integral_D f
    <= integral_D abs(f).
  $

  Suy ra
  $
    abs(integral_D f) <= integral_D abs(f).
  $
]
#baitoan[
  *Bài toán 3.35.* \* Chứng minh rằng nếu $f$ khả tích trên $D$ thì $|f|$ cũng khả tích trên $D$.
]
#loigiai[

  Lấy hình hộp $I subset RR^n$ sao cho $D subset I$, khi đó giả sử $f$ khả tích trên $D$, ta chứng minh $abs(f)$ khả tích trên $D$. Thật vậy, đặt
  $
  F(x)=cases(f(x) &: x in D,0 &: x in I backslash D)
  $
  Do đó, $F(x)$ khả tích trên $I$. Ta chứng minh $abs(F(x))$ khả tích trên $I$.


  Thật vậy, cho trước $epsilon>0$, tìm phân hoạch $P(epsilon) subset I$ sao cho $U(abs(F(x)))-L(abs(F(x)))<epsilon$.

  Vì $F$ khả tích trên $I$, nên ta có với bất kỳ $epsilon_1>0$, có phân hoạch $Q(epsilon_1) subset I$ sao cho $U(F(x))-L(F(x))<epsilon_1$.

  Trong đó, $U(abs(F(x)))-L(abs(F(x)))=sum_(i=1)^m abs((M_i-m_i))abs(P_i)$, với $M_i=sup_(x in Q_i) abs(F(x))$ và $m_i=inf_(x in Q_i) abs(F(x))$, lại có
  $M'(i)=sup_(x in Q_i) f(x)$, $m'(i)=inf_(x in Q_i) f(x)$. Ta sẽ chứng minh $M-m<=M'-m$.Do đó, nếu chọn phân hoạch $Q(epsilon_1) $ và xét $epsilon_1=epsilon$, thì với bất kỳ hình hộp con $U $ của phân hoạch $Q$. Thì ta luôn có $forall x,y in U$.

  $
  abs(F(x))-abs(F(y))<=abs((abs(F(x))-abs(F(y))))<=abs(F(x)-F(y)).<= M'_U-m'_U
<=> abs(F(x))<=abs(F(y))+M'_Q-m'_q
  $
  Vì đúng với bất kỳ $x,y in U$, nên do đó
  $
  M_U-m_U<=M'_U-m'_U
  $
  Do đó, với phân hoạch $Q$ được chọn, ta luôn có
  $
  U(abs(F),Q)-L(abs(F),Q)<=U(F,Q)-L(F,Q)<epsilon.
  $
  Do đó, $abs(F)$ khả tích trên $I$ nên suy ra $abs(f)$ khả tích trên $D$.
]

#baitoan[
  *Bài toán 3.36.* \* Chứng tỏ tích phân của một hàm bị chặn trên một tập có thể tích không thì bằng không.
]
#loigiai[
  Giả sử $D subset RR^n$ có thể tích Jordan bằng không và $f : D -> RR$ là hàm bị chặn.

  Khi đó, tồn tại $M >= 0$ sao cho
  $
    abs(f(x)) <= M, quad forall x in D.
  $

  Lấy hình hộp $I subset RR^n$ sao cho $D subset I$. Đặt
  $
    F(x) = cases(
      f(x) & "nếu" x in D,
      0 & "nếu" x in.not D.
    )
  $
  và hàm đặc trưng
  $
    chi_D(x) = cases(
      1 & "nếu" x in D,
      0 & "nếu" x in.not D.
    )
  $

  Vì $D$ có thể tích Jordan bằng không nên $chi_D$ khả tích trên $I$ và
  $
    integral_I chi_D = V(D) = 0.
  $

  Mặt khác, với mọi $x in I$, ta có
  $
    -M chi_D(x) <= F(x) <= M chi_D(x).
  $

  Ta chứng minh $F$ khả tích trên $I$.

  Nếu $M=0$ thì $F=0$, nên kết luận hiển nhiên.

  Xét $M>0$. Vì $chi_D$ khả tích trên $I$ với tích phân bằng không, nên với mọi $epsilon>0$, tồn tại phân hoạch $P$ của $I$ sao cho
  $
    U(chi_D,P) < epsilon/(2M).
  $

  Từ bất đẳng thức
  $
    -M chi_D <= F <= M chi_D,
  $
  suy ra
  $
    U(F,P) &<= M U(chi_D,P), \
    L(F,P) &>= -M U(chi_D,P).
  $

  Do đó,
  $
    U(F,P)-L(F,P)
    &<= 2M U(chi_D,P) \
    &< epsilon.
  $

  Theo tiêu chuẩn Darboux, $F$ khả tích trên $I$. Suy ra $f$ khả tích trên $D$.

  Áp dụng tính đơn điệu và tuyến tính của tích phân, ta được
  $
    -M integral_I chi_D
    <= integral_I F
    <= M integral_I chi_D.
  $

  Vì $integral_I chi_D=0$, nên
  $
    0 <= integral_I F <= 0.
  $

  Vậy
  $
    integral_D f = integral_I F = 0.
  $
]
#baitoan[
  *Bài toán 3.37.* \* Giả sử hàm $f$ liên tục trên hình hộp $I$ và $f(x) >= 0$ trên $I$. Chứng minh rằng nếu $integral_I f = 0$ thì $f = 0$ trên $I$. Điều này có còn đúng không nếu bỏ giả thiết liên tục?
]
#loigiai[
  Giả sử $I subset RR^n$ là hình hộp có thể tích dương.

  Vì $f$ liên tục trên hình hộp compact $I$ nên $f$ khả tích Riemann trên $I$.

  Ta chứng minh bằng phương pháp phản chứng.

  Giả sử tồn tại $x_0 in I$ sao cho
  $
    f(x_0) > 0.
  $

  Đặt $c=f(x_0)/2>0$.

  Vì $f$ liên tục tại $x_0$, nên tồn tại $delta>0$ sao cho
  $
    norm(x-x_0) < delta
    => abs(f(x)-f(x_0)) < c
  $
  với mọi $x in I$.

  Suy ra
  $
    f(x) > f(x_0)-c = c
  $
  với mọi $x in I$ thỏa mãn $norm(x-x_0)<delta$.

  Vì $I$ là hình hộp có thể tích dương, ta có thể chọn một hình hộp con $J subset I$ với $V(J)>0$ sao cho
  $
    J subset {x in RR^n : norm(x-x_0)<delta}.
  $

  Khi đó, $f(x)>=c$ với mọi $x in J$. Theo tính đơn điệu của tích phân, ta có
  $
    integral_I f
    &>= integral_J f \
    &>= integral_J c \
    &= c V(J) \
    &> 0.
  $

  Điều này mâu thuẫn với giả thiết $integral_I f=0$.

  Vậy
  $
    f(x)=0, quad forall x in I.
  $

  *Nếu bỏ giả thiết liên tục thì kết luận không còn đúng.*

  Thật vậy, xét $I=[0,1]$ và hàm
  $
    f(x)=cases(
      1 & "nếu" x=1/2,
      0 & "nếu" x != 1/2.
    )
  $

  Hàm $f$ bị chặn và chỉ gián đoạn tại $x=1/2$.

  Vì tập ${1/2}$ có độ dài Jordan bằng không nên theo Bài toán 3.36, $f$ khả tích Riemann trên $I$ và
  $
    integral_0^1 f(x) dif x = 0.
  $

  Tuy nhiên,
  $
    f(1/2)=1 != 0.
  $

  Do đó, nếu bỏ giả thiết liên tục thì từ $f>=0$ và $integral_I f=0$ không thể kết luận $f=0$ trên toàn bộ $I$.
]
#baitoan[
  *Bài toán 3.38.* \* Tìm tập $D subset RR^2$ sao cho tích phân

  $ integral.double_D (1 - x^2 - y^2) dif A $

  đạt giá trị lớn nhất.
]
#loigiai[
  Đặt $f(x,y)=1-x^2-y^2$ và xét hình tròn đóng
  $
    B = {(x,y) in RR^2 : x^2+y^2 <= 1}.
  $

  Nhận thấy
  $
    cases(
      f(x,y) >= 0 & "nếu" (x,y) in B,
      f(x,y) < 0 & "nếu" (x,y) in.not B.
    )
  $

  Ta chứng minh rằng với mọi miền $D subset RR^2$ có diện tích Jordan, ta luôn có
  $
    integral.double_D f <= integral.double_B f.
  $

  Thật vậy, lấy hình hộp $I subset RR^2$ chứa cả $D$ và $B$. Gọi $chi_D$ và $chi_B$ lần lượt là các hàm đặc trưng của $D$ và $B$.

  Với mọi $(x,y) in I$, ta có
  $
    chi_D(x,y) f(x,y) <= chi_B(x,y) f(x,y).
  $

  Thật vậy:

  - Nếu $(x,y) in B$, vì $f(x,y)>=0$ và $chi_D(x,y)<=1$, nên
    $
      chi_D(x,y)f(x,y)
      <= f(x,y)
      = chi_B(x,y)f(x,y).
    $

  - Nếu $(x,y) in.not B$, vì $f(x,y)<0$, nên
    $
      chi_D(x,y)f(x,y)
      <= 0
      = chi_B(x,y)f(x,y).
    $

  Theo tính đơn điệu của tích phân, suy ra
  $
    integral.double_D f
    &= integral.double_I chi_D f \
    &<= integral.double_I chi_B f \
    &= integral.double_B f.
  $

  Như vậy, tích phân đạt giá trị lớn nhất khi chọn $D=B$.

  Đổi sang tọa độ cực $x=r cos theta$, $y=r sin theta$, ta được
  $
    integral.double_B (1-x^2-y^2) dif A
    &= integral_0^(2 pi) integral_0^1
       (1-r^2)r dif r dif theta \
    &= 2 pi [r^2/2-r^4/4]_0^1 \
    &= pi/2.
  $

  Vậy có thể chọn
  $
    D = {(x,y) in RR^2 : x^2+y^2 <= 1},
  $
  và giá trị lớn nhất của tích phân là $pi/2$.
]

#baitoan[
  *Bài toán 3.39.* \* Chứng tỏ tập hợp tất cả các số hữu tỉ giữa $0$ và $1$ là không có chiều dài.
]
#loigiai[
  Xét tập hợp
  $
    A = QQ inter (0,1).
  $

  Ta chứng minh $A$ không có chiều dài Jordan bằng cách chỉ ra rằng biên $partial A$ không có chiều dài bằng không.

  Vì tập hợp các số hữu tỉ trù mật trong $RR$, nên
  $
    overline(A) = [0,1].
  $

  Mặt khác, vì giữa hai số thực phân biệt bất kỳ luôn tồn tại một số vô tỉ, nên không tồn tại khoảng mở nào nằm hoàn toàn trong $A$.

  Do đó,
  $
    i n t(A) = emptyset.
  $

  Suy ra
  $
    partial A = overline(A) = [0,1].
  $

  Vì
  $
    V(partial A) = V([0,1]) = 1 != 0,
  $
  nên $partial A$ không có chiều dài bằng không.

  Theo tiêu chuẩn Jordan, một tập bị chặn có chiều dài Jordan khi và chỉ khi biên của nó có chiều dài bằng không.

  Vậy $A$ không có chiều dài Jordan.
]

#baitoan[
  *Bài toán 3.40.* \* Chứng tỏ một tập con bị chặn của $RR^n$ có thể tích không khi và chỉ khi nó có thể tích và thể tích đó bằng không. Như vậy “thể tích không” chính là “thể tích bằng không”!
]
#loigiai[
  Giả sử $A subset RR^n$ là một tập bị chặn. Lấy hình hộp $I subset RR^n$ sao cho $A subset I$.

  Ta chứng minh hai chiều.

  *($=>$) Giả sử $A$ có thể tích không.*

  Theo định nghĩa, với mọi $epsilon>0$, tồn tại hữu hạn hình hộp $Q_1,dots,Q_m$ sao cho
  $
    A subset union_(i=1)^m Q_i
  $
  và
  $
    sum_(i=1)^m V(Q_i) < epsilon.
  $

  Đặt
  $
    F(x) = cases(
      1 & "nếu" x in A,
      0 & "nếu" x in.not A.
    )
  $

  Xét các hàm đặc trưng $chi_(Q_i)$. Vì mỗi hình hộp có thể tích Jordan nên $chi_(Q_i)$ khả tích trên $I$.

  Thay $Q_i$ bởi $Q_i inter I$ nếu cần, ta có thể giả sử mọi $Q_i subset I$.

  Đặt
  $
    H(x) = sum_(i=1)^m chi_(Q_i)(x).
  $

  Khi đó $H$ khả tích trên $I$ và
  $
    integral_I H
    = sum_(i=1)^m V(Q_i) < epsilon.
  $

  Mặt khác, vì các hình hộp $Q_i$ phủ $A$ nên
  $
    0 <= F(x) <= H(x), quad forall x in I.
  $

  Do $H$ khả tích trên $I$, tồn tại phân hoạch $P$ của $I$ sao cho
  $
    U(H,P) < integral_I H + epsilon < 2 epsilon.
  $

  Suy ra
  $
    0 <= L(F,P) <= U(F,P) <= U(H,P) < 2 epsilon.
  $

  Do đó,
  $
    U(F,P)-L(F,P)<2 epsilon.
  $

  Vì $epsilon>0$ tùy ý nên theo tiêu chuẩn Darboux, $F$ khả tích trên $I$.

  Hơn nữa, từ
  $
    0 <= integral_I F <= U(F,P)<2 epsilon
  $
  với mọi $epsilon>0$, suy ra
  $
    integral_I F=0.
  $

  Vậy $A$ có thể tích Jordan và $V(A)=0$.

  *($<=$) Giả sử $A$ có thể tích Jordan và $V(A)=0$.*

  Khi đó hàm đặc trưng $chi_A$ khả tích trên $I$ và
  $
    integral_I chi_A=V(A)=0.
  $

  Với mọi $epsilon>0$, vì $chi_A$ khả tích trên $I$, nên tồn tại phân hoạch $P$ của $I$ sao cho
  $
    U(chi_A,P)<epsilon.
  $

  Gọi $Q_1,dots,Q_m$ là tất cả các hình hộp con của phân hoạch $P$ có giao khác rỗng với $A$.

  Khi đó,
  $
    A subset union_(i=1)^m Q_i.
  $

  Mặt khác, vì $chi_A$ nhận giá trị $1$ tại ít nhất một điểm thuộc mỗi $Q_i$, nên
  $
    sup_(x in Q_i) chi_A(x)=1.
  $

  Do đó,
  $
    sum_(i=1)^m V(Q_i)
    = U(chi_A,P)
    < epsilon.
  $

  Như vậy, với mọi $epsilon>0$, ta đều tìm được một phủ hữu hạn của $A$ bởi các hình hộp có tổng thể tích nhỏ hơn $epsilon$.

  Theo định nghĩa, $A$ có thể tích không.

  Vậy
  $
    A " có thể tích không"
    <=> V(A)=0.
  $
]

= Tuần 4
== Công Thức Fubini

Công thức Fubini#super[1] trong mặt phẳng có dạng:

$
  integral.double_([a,b] times [c,d]) f(x,y) dif x dif y
  &= integral_a^b (integral_c^d f(x,y) dif y) dif x \
  &= integral_c^d (integral_a^b f(x,y) dif x) dif y.
$ 
#align(right)[(4.1)]

Một tích phân của tích phân như ở vế phải của (4.1) được gọi là một *tích phân lặp*#super[2]. Công thức Fubini đưa bài toán tính tích phân của hàm nhiều biến về bài toán tính tích phân của hàm một biến, hay còn được nói là _đưa tích phân bội về tích phân lặp_.
#chungminh[

  *Công Thức Fubini*
  Ta chứng minh với $n=2$, trường hợp tổng quát tương tự.

  $
  integral.double_([a,b]times[c,d]) f(x,y) dif x dif y&=integral_a^b (integral_c^d f(x,y) dif y) dif x\
  &tilde sum_(i,j) f(x_i,y_i)(triangle x_i times triangle y_i)=sum_(i) (sum_j f(x_i,y_i) triangle y_j) triangle x_i
  $
  Có nghĩa là, cố định $x_i$, ta lấy tích phân theo biến $y$. Nói cách khác, $f(x_i,y_i)$ bây giờ là hàm một biến theo $y_i$. Khi đó, biểu thức
  $
 &sum_(j) f(x_j,y_j) triangle y_j "là tổng Riemann của hàm" y-> f(x_i,y)\
 ~& sum_i (integral_c^d f(x_i,y)dif y) triangle x_i
  $
  Hơn nữa, $
  sum_i (integral_c^d f(x_i,y)dif y) triangle x_i~ integral_a^b (integral_c^d f(x,y) dif y) dif x 
  $
  Lập luận bằng ngôn ngữ $epsilon$, khi đó
  $
  forall epsilon>0, &abs(integral.double_([a,b] times [c,d])f(x,y) dif x dif y- sum_(i,j) f(x_i,y_i) triangle x_i triangle y_i) \
&=abs(integral.double_([a,b] times [c,d]) f(x,y) dif x dif y-sum_i (sum_j f(x_i,y_i) triangle y_i) triangle x_i)\
&=abs(integral_c^d f(x_i,y) dif y - sum_j f(x_i,y_j) triangle y_j)<epsilon

  
  $
  Chia $[c,d]$ đủ nhỏ với mỗi $i$ lấy đủ nhỏ nhất $delta=min_i delta _i$
]
#vidu[ Để nhanh chóng minh họa, ta thử dùng Công thức Fubini để tính
$integral.double_([0,1] times [2,4]) x y dif x dif y$.

Giả sử công thức Fubini áp dụng được:

$
  integral.double_([0,1] times [2,4]) x y dif x dif y
  &= integral_0^1 (integral_2^4 y dif y) x dif x \
  &= (integral_2^4 y dif y)(integral_0^1 x dif x) \
  &= 1/2 y^2 |_(y=2)^(y=4) 1/2 x^2 |_(x=0)^(x=1) = 3.
$

Áp dụng công thức Fubini theo thứ tự ngược lại:

$
  integral.double_([0,1] times [2,4]) x y dif x dif y
  &= integral_2^4 (integral_0^1 x dif x) y dif y \
  &= (integral_0^1 x dif x)(integral_2^4 y dif y) = 3.
$
]

Về hình học có thể giải thích Công thức Fubini như ở Hình 4.2.

Còn có thể giải thích công thức Fubini bằng cách xấp xỉ thể tích của khối như sau. Chia khoảng $[a,b]$ thành những khoảng con. Ứng với những khoảng con này, khối được cắt thành những mảnh bởi những mặt cắt song song. Vì chiều dài mỗi khoảng con là nhỏ, ta có thể xấp xỉ thể tích của mỗi mảnh bởi diện tích một mặt cắt nhân với chiều dài của khoảng con. Giải thích này cũng gợi ý tên gọi đây là #text(fill: rgb("#8766E8"), weight: "bold")[phương pháp cắt lớp].

#align(center)[
  #image("Tong Hop Hinh/hinh 4-2.png", width: 78%)
]

#align(center)[
  #text(size: 9pt)[
    *Hình 4.2:* Với $f > 0$ thì
    $integral.double_([a,b] times [c,d]) f$
    là "thể tích" của khối bên dưới mặt
    $z = f(x,y)$ bên trên hình chữ nhật
    $[a,b] times [c,d]$, còn
    $integral_c^d f(x_0,y) dif y$
    là "diện tích" của mặt cắt của khối
    bởi mặt phẳng $x = x_0$. Vậy Công thức
    Fubini (4.1) nói rằng
    #text(fill: rgb("#D96B19"), style: "italic")[
      thể tích của khối bằng tổng diện tích
      các mặt cắt song song.
    ]
  ]
]

Chi tiết hơn, ta xấp xỉ theo tổng Riemann như sau. Giả sử $a = x_0 < x_1 < dots < x_m = b$ là một phép chia của khoảng $[a,b]$ và $c = y_0 < y_1 < dots < y_n = d$ là một phép chia của khoảng $[c,d]$.

Với $x_i^*$ là điểm đại diện bất kì thuộc khoảng con $Delta x_i = [x_(i-1), x_i]$ và $y_j^*$ là điểm đại diện bất kì thuộc $Delta y_j = [y_(j-1), y_j]$, xem Hình 1.6, thì

$
  integral.double_([a,b] times [c,d]) f(x,y) dif x dif y
  &approx sum_(1 <= i <= m, 1 <= j <= n)
  f(x_i^*, y_j^*) abs(Delta x_i times Delta y_j) \

  &= sum_(1 <= i <= m, 1 <= j <= n)
  f(x_i^*, y_j^*) abs(Delta x_i) abs(Delta y_j) \

  &= sum_(i=1)^m
  (sum_(j=1)^n f(x_i^*, y_j^*) abs(Delta y_j))
  abs(Delta x_i) \

  &approx sum_(i=1)^m
  (integral_c^d f(x_i^*,y) dif y)
  abs(Delta x_i) \

  &approx integral_a^b
  (integral_c^d f(x,y) dif y) dif x.
$

Giải thích trên cho thấy Công thức Fubini tương ứng với việc tính tổng Riemann trên các hình hộp con lần lượt theo cột hoặc lần lượt theo hàng.

#dinhly[
  
*Công thức Fubini*

Cho $A$ là một hình hộp trong $RR^m$ và $B$ là một hình hộp trong $RR^n$. Cho $f$ khả tích trên hình hộp $A times B$ trong $RR^(m+n)$. Giả sử với mỗi $x in A$ tích phân $integral_B f(x,y) dif y$ tồn tại, khi đó

#align(center)[
  #box(fill: rgb("#E4F1F2"), inset: 8pt)[
    $
      integral.double_(x in A, y in B) f(x,y) d x d y =integral_(A times B) f
      = integral_A (integral_B f(x,y) dif y) dif x.
    $
  ]
]

Tương tự, giả sử với mỗi $y in B$ tích phân $integral_A f(x,y) dif x$ tồn tại, khi đó

#align(center)[
  #box(fill: rgb("#E4F1F2"), inset: 8pt)[
    $
      integral_(A times B) f
      = integral_B (integral_A f(x,y) dif x) dif y.
    $
  ]
]

]
#vidu[
  Ta tính
$integral.double_([0,4] times [0,2]) (x + 2y) dif x dif y$.

Vì hàm $(x,y) mapsto x + 2y$ là liên tục trên hình chữ nhật $[0,4] times [0,2]$ nên tích phân trên tồn tại. Công thức Fubini áp dụng được, cho:

$
  integral.double_([0,4] times [0,2]) (x+2y) dif x dif y
  &= integral_0^4 (integral_0^2 (x+2y) dif y) dif x \
  &= integral_0^4 (x y + y^2)|_(y=0)^(y=2) dif x \
  &= integral_0^4 (2x+4) dif x \
  &= (x^2 + 4x)|_(x=0)^(x=4) = 32.
$

Ta cũng có thể áp dụng Công thức Fubini theo thứ tự khác:

$
  integral.double_([0,4] times [0,2]) (x+2y) dif x dif y
  &= integral_0^2 (integral_0^4 (x+2y) dif x) dif y \
  &= integral_0^2 (1/2 x^2 + 2x y)|_(x=0)^(x=4) dif y \
  &= integral_0^2 (8+8y) dif y \
  &= (8y + 4y^2)|_(y=0)^(y=2) = 32.
$

]
#vidu[
  Tính diện tích hình tròn. Xét hình tròn đơn vị $x^2+y^2<=1$.
  #figure(
    image("Tong Hop Hinh/hinh-tron.png",width : 55%)
  )
  Lấy hình hộp $I=[-1,1]times[-1,1]$. Khi đó,

  
  $|D|=integral.double_D 1 dif x dif y=integral_I chi_D (x,y) dif x dif y$. Theo Fubini, $
  integral.double_I chi_D (x,y) dif x dif y=integral_(-1<=x<=1) (integral_(-1<=y<=1) chi_(D) (x,y) dif y) dif x
  $
  Với $

  chi_D(x,y)&=cases(1 &: (x,y) in D, 0 &: (x,y) in.not D)\
  &=cases(1 &: -sqrt(1-x^2) <=y <= sqrt(1-x^2), 0&: "còn lại").
  $
  Khi đó, 
  $
  integral_(-1<=x<=1) (integral_(-1<=y<=1) chi_(D) (x,y) dif y) dif x=integral_(-1<=x<=1) (integral_(- sqrt(1-x^2))^(sqrt(1-x^2))1 dif y) dif x
  $
  
]
#box(
  fill: rgb("#E2EFF0"),
  inset: 8pt,
  width: 100%,
)[
  *4.7 Hệ quả* #text(fill: rgb("#8766E8"), weight: "bold")[(thể tích của miền dưới đồ thị).]

  _Giả sử $f$ là hàm xác định và không âm trên miền bị chặn $D subset RR^n$. Gọi $E$ là miền dưới đồ thị của $f$ bên trên miền $D$, tức_

  $ E = { (x,y) in RR^n times RR | x in D, 0 <= y <= f(x) }. $

  _Nếu $E$ có thể tích thì $f$ khả tích và thể tích của $E$ bằng tích phân của $f$ trên $D$:_

  $
    |E| = integral_D f.
  $
]

Vậy #text(fill: rgb("#D96B19"), style: "italic")[
  thể tích bên dưới đồ thị bằng tích phân của hàm.
] Ta đã hướng tới điều này từ đầu khi xây dựng tích phân nhưng tới giờ mới thu được.
#chungminh[
  Vì $E$ có thể tích nên nó bị chặn, có một hình hộp chứa nó. Ta có thể lấy hình hộp đó là $I times [0,c]$ với $I$ là một hình hộp $n$-chiều trong $RR^n$ chứa $D$ và $c$ đủ lớn.

#figure(
  image("Tong Hop Hinh/hinh 4-8.png", width: 65%),
)

Áp dụng Định lý 4.3:

$
  |E|
  &= integral_E 1
  = integral_(I times [0,c]) chi_E \
  &= integral_I (integral_0^c chi_E(x,y) dif y) dif x \
  &= integral_D (integral_0^c chi_E(x,y) dif y) dif x \
  &= integral_D f(x) dif x.
$

Trong tính toán trên, chú ý nếu $x in I without D$ thì $chi_E(x,y) = 0$ nên

$
  integral_0^c chi_E(x,y) dif y = 0,
$

còn nếu $x in D$ thì $chi_E(x,y) = 1$ khi và chỉ khi $0 <= y <= f(x)$, nên

$
  integral_0^c chi_E(x,y) dif y
  = integral_0^(f(x)) 1 dif y
  = f(x).
$
]

== Công thức Fubini cho miền phẳng

Công thức Fubini áp dụng dễ dàng hơn đối với những miền "đơn giản". Một tập con của $RR^2$ được gọi là một #text(fill: rgb("#8766E8"), weight: "bold")[miền đơn giản theo chiều đứng] nếu nó có dạng

$
  { (x,y) in RR^2 | a <= x <= b, g(x) <= y <= h(x) }.
$

Đây là một miền giữa hai đồ thị có cùng miền xác định. Một đường thẳng đứng nếu cắt miền này thì phần giao là một đoạn thẳng.

Tương tự, một tập con của $RR^2$ được gọi là một #text(fill: rgb("#8766E8"), weight: "bold")[miền đơn giản theo chiều ngang] nếu nó có dạng

$
  { (x,y) in RR^2 | c <= y <= d, g(y) <= x <= h(y) }.
$

#align(center)[
  #image("Tong Hop Hinh/hinh 4-9.png", width: 65%)
]

#menhde[
  *4.10 Mệnh đề.* Cho miền đơn giản theo chiều đứng

  $
    D = { (x,y) in RR^2 | a <= x <= b,
    g(x) <= y <= h(x) }.
  $

  Giả sử $f$, $g$ và $h$ liên tục. Khi đó

  $
    integral.double_D f(x,y) dif x dif y
    = integral_a^b
    (integral_(g(x))^(h(x)) f(x,y) dif y) dif x.
  $
]

Công thức có thể đúng dưới những điều kiện tổng quát hơn như ở 4.7 nhưng ta chỉ phát biểu ở dạng thường dùng trong môn học này. Trường hợp miền đơn giản theo chiều nằm ngang là tương tự.

Trong trường hợp tính tích phân trên một miền không đơn giản ta có thể tìm cách chia miền này thành những miền đơn giản, rồi dùng Mệnh đề 3.17.


#vidu[ (#text(fill: rgb("#8766E8"), weight: "bold")[diện tích miền nằm giữa hai đồ thị]).

Cho $f = 1$, ta được diện tích của miền nằm giữa đồ thị của hai hàm liên tục $g$ và $h$, với $g <= h$, bên trên đoạn $[a,b]$, là

$
  integral_a^b [h(x) - g(x)] dif x.
$

Đặc biệt nếu $g = 0$ thì diện tích bên dưới đồ thị hàm liên tục $h$ là $integral_a^b h(x) dif x$.

Trong môn Vi tích phân 1 các công thức này thường được lấy làm định nghĩa [BMGT].
]
#vidu[ (#text(fill: rgb("#8766E8"), weight: "bold")[diện tích tam giác vuông]).

Xét $D$ là tam giác với các đỉnh $(0,0)$, $(a,0)$, $(a,b)$, với $a,b > 0$. Đây là miền dưới đồ thị $y = b/a x$ với $0 <= x <= a$. Ta tính

$
  |D| = integral_0^a b/a x dif x = 1/2 a b.
$

Vậy diện tích này bằng nửa tích chiều dài hai cạnh góc vuông.
]

#vidu[
  *Ví dụ.* Tính $integral.double_D e^(y^2) dif A$, với $D$ là tam giác với các đỉnh $(0,0)$, $(4,2)$, $(0,2)$.

  Ta có thể miêu tả $D$ theo hai cách

  $
    D &= { (x,y) in RR^2 | 0 <= x <= 4, x/2 <= y <= 2 } \
      &= { (x,y) in RR^2 | 0 <= y <= 2, 0 <= x <= 2y }.
  $

  Để thấy hai cách miêu tả này tương đương, ta có thể dùng trực quan hình học qua hình vẽ, hoặc biến đổi mỗi hệ bất phương trình dẫn tới hệ còn lại.

  Các giả thiết ở Mệnh đề 4.10 để áp dụng công thức Fubini được thỏa cho cả hai cách miêu tả.

  Theo cách miêu tả thứ nhất, tức là xem $D$ là miền đơn giản theo chiều đứng, thì công thức Fubini cho:

  $
    I = integral.double_D e^(y^2) dif A
    = integral_0^4 (integral_(x/2)^2 e^(y^2) dif y) dif x.
  $

  Tuy nhiên người ta biết nguyên hàm của hàm $e^(y^2)$ theo biến $y$ không phải là một hàm sơ cấp, do đó không có công thức sơ cấp cho nó, khiến ta không tính được tích phân lặp này bằng cách lấy nguyên hàm thông thường.

  Ta chuyển hướng dùng cách miêu tả thứ hai, xem $D$ là miền đơn giản theo chiều ngang. Ta đổi thứ tự tích phân lặp:

  $
    I &= integral_0^2 (integral_0^(2y) e^(y^2) dif x) dif y \
      &= integral_0^2 x e^(y^2) |_(x=0)^(x=2y) dif y \
      &= integral_0^2 2y e^(y^2) dif y \
      &= e^(y^2) |_(y=0)^(y=2) \
      &= e^4 - 1.
  $

  Đây là một ví dụ cho #text(fill: rgb("#8766E8"), weight: "bold")[phương pháp đổi thứ tự tích phân lặp].
]
#pagebreak()
== Công thức Fubini cho miền ba chiều

Tương tự trường hợp hai chiều ta có thể nói về miền ba chiều đơn giản. Một tập con của $RR^3$ được gọi là một #text(fill: rgb("#8766E8"), weight: "bold")[miền đơn giản theo chiều trục $z$] nếu nó có dạng

$
  { (x,y,z) in RR^3 | (x,y) in D,
    g(x,y) <= z <= h(x,y) }.
$

Đây là miền nằm giữa hai đồ thị có cùng miền xác định. Một đường thẳng cùng phương với trục $z$ nếu cắt miền này thì phần giao là một đoạn thẳng. Xem Hình 4.15. Tương tự có khái niệm miền đơn giản theo chiều trục $x$ và trục $y$.

#figure(
  image("Tong Hop Hinh/hinh 4-15.png", width: 75%),
  caption: [Miền ba chiều đơn giản theo chiều trục $z$.],
)

Tương tự trường hợp hai chiều 4.10, ta có:

#menhde[
  *4.16 Mệnh đề.* Cho miền $D subset RR^2$ đóng có diện tích, và cho miền đơn giản theo chiều trục $z$ là

  $
    E = { (x,y,z) in RR^3 | (x,y) in D,
      g(x,y) <= z <= h(x,y) }.
  $

  Giả sử $f$, $g$ và $h$ liên tục thì

  $
    integral.triple_E f(x,y,z) dif x dif y dif z
    = integral.double_D
    (integral_(g(x,y))^(h(x,y))
    f(x,y,z) dif z) dif x dif y.
  $
]

#vidu[
  *4.17 Ví dụ.* Tính $integral.triple_E x dif V$ với $E$ là khối tứ diện với các đỉnh $(0,0,0)$, $(1,0,0)$, $(0,2,0)$, $(0,0,3)$.

  Bước chính là miêu tả khối $E$. Ta xem $E$ là một khối đơn giản theo chiều trục $z$, là miền bên dưới mặt phẳng $P$ qua ba điểm $(1,0,0)$, $(0,2,0)$, $(0,0,3)$ và bên trên tam giác $D$ với các đỉnh $(0,0,0)$, $(1,0,0)$, $(0,2,0)$ trong mặt phẳng $x y$.

  #figure(
    image("Tong Hop Hinh/hinh 4-16.png", width: 65%),
  )

  Ta viết phương trình mặt phẳng $P$. Một cách là tìm một vectơ pháp tuyến.

  Lấy hai vectơ $(0,0,3) - (1,0,0) = (-1,0,3)$ và $(0,0,3) - (0,2,0) = (0,-2,3)$, tích có hướng là

  $
    (-1,0,3) times (0,-2,3) = (6,3,2)
  $

  là một vectơ pháp tuyến của $P$.

  Một điểm $(x,y,z)$ nằm trên $P$ khi và chỉ khi vectơ $(x,y,z) - (0,0,3)$ vuông góc với vectơ pháp tuyến $(6,3,2)$, đồng nghĩa với tích vô hướng của hai vectơ này bằng $0$, vậy phương trình của $P$ là

  $
    (x,y,z-3) dot (6,3,2) = 0,
  $

  tức là

  $
    6x + 3y + 2z = 6.
  $

  Ta cũng có thể dùng dạng tổng quát của phương trình mặt phẳng là $a x + b y + c z = d$ và thế các điểm đã cho vào ta cũng rút ra được phương trình của $P$.

  Từ phương trình của mặt phẳng $P$ ta rút ra

  $
    z = (6 - 6x - 3y)/2,
  $

  cho thấy $E$ có thể được xem như một khối đơn giản theo chiều trục $z$, là khối nằm dưới đồ thị của hàm $z = (6 - 6x - 3y)/2$ bên trên miền $D$ trong mặt phẳng $x O y$:

  $
    E = { (x,y,z) in RR^3 :
    (x,y) in D, 0 <= z <= (6-6x-3y)/2 }.
  $

  Điều này cho

  $
    integral.triple_E x dif V
    = integral.double_D
    (integral_0^(3-3x-3/2 y) x dif z)
    dif x dif y.
  $

  Tiếp theo ta có thể chọn coi tam giác $D$ là miền đơn giản theo chiều trục $y$ trong mặt phẳng $x y$:

  $
    D = { (x,y) in RR^2 :
    0 <= x <= 1, 0 <= y <= 2-2x }.
  $

  Khi thông thạo hơn ta có thể kết hợp hai bước trên để miêu tả

  $
    E = { (x,y,z) in RR^3 :
    0 <= x <= 1,
    0 <= y <= 2-2x,
    0 <= z <= (6-6x-3y)/2 }.
  $

  Các điều kiện áp dụng Công thức Fubini ở 4.16 đều được thỏa,

  $
    integral.triple_E x dif V
    &= integral_0^1 (
      integral_0^(2-2x) (
      integral_0^(3-3x-3/2 y) x dif z
      ) dif y
      ) dif x \

    &= integral_0^1 (
      integral_0^(2-2x)
      x(3-3x-3/2 y) dif y
      ) dif x \

    &= integral_0^1
      (x(3-3x)y - 3/4 x y^2)|_(y=0)^(y=2-2x)
      dif x \

    &= integral_0^1
      (3x^3 - 6x^2 + 3x) dif x
      = 1/4.
  $
]
#pagebreak()
#vidu[
  *Ví dụ.* Cho $E subset RR^3$ là khối được bao bởi các mặt $z = 0$, $z = 2$, $y = 0$, $y = 1 - x^2$. Tính $integral.triple_E y dif V$.

  Khối được miêu tả dựa vào trực quan vì thế ta nên phác họa hình hay dùng máy tính để vẽ hình.

  #align(center)[
    #image("Tong Hop Hinh/hinh 4-18.png", width: 65%)
  ]

  #align(center)[*Hình 4.18*]

  Với trợ giúp từ Hình 4.18, ta nhìn $E$ như một khối trụ theo chiều trục $z$,

  $
    E = { (x,y,z) in RR^3 :
    (x,y) in D, 0 <= z <= 2 }
  $

  với

  $
    D = { (x,y) in RR^2 :
    -1 <= x <= 1, 0 <= y <= 1-x^2 }
  $

  hay

  $
    E = { (x,y,z) in RR^3 :
    -1 <= x <= 1,
    0 <= y <= 1-x^2,
    0 <= z <= 2 }.
  $

  Xem $E$ là một khối đơn giản theo chiều trục $z$, các điều kiện ở Công thức Fubini 4.16 đều được thỏa,

  $
    integral.triple_E y dif V
    = integral_0^2
    (integral.double_D y dif x dif y) dif z.
  $

  Xem $D$ là miền đơn giản theo chiều trục $y$ và áp dụng Công thức Fubini,

  $
    integral.triple_E y dif V
    &= integral_0^2
    (integral.double_D y dif x dif y) dif z \

    &= integral_0^2
    (integral_(-1)^1
    (integral_0^(1-x^2) y dif y) dif x) dif z \

    &= integral_0^2
    (integral_(-1)^1
    1/2 y^2|_(y=0)^(y=1-x^2) dif x) dif z \

    &= integral_0^2
    (integral_(-1)^1
    1/2 (1-2x^2+x^4) dif x) dif z \

    &= integral_0^2 1/2 dot 16/15 dif z
    = 16/15.
  $
]

== Phương pháp cắt lớp cho thể tích

Giả sử tập $E subset RR^3$ có thể tích. Giả sử $a <= z <= b$ với mọi $(x,y,z) in E$. Giả sử với mỗi $z in [a,b]$ tập

$
  E_z = { (x,y) in RR^2 : (x,y,z) in E }
$

có diện tích. Tập $E_z$ tương ứng với mặt cắt (hay thiết diện) của khối $E$ bởi mặt phẳng vuông góc trục $z$ tại tọa độ $z$. Xem Hình 4.19.

#align(center)[
  #image("Tong Hop Hinh/hinh 4-19.png", width: 75%)
]

#align(center)[
  *Hình 4.19:* Tính thể tích khối bằng phương pháp cắt lớp.
]

Đặt $E$ vào trong một hình hộp $I times [a,b]$ với $I$ là một hình chữ nhật trong $RR^2$. Áp dụng Công thức Fubini cho hình hộp $I times [a,b]$ và hàm $chi_E$,

$
  |E|
  &= integral.triple_(I times [a,b]) chi_E dif x dif y dif z \
  &= integral_a^b
     (integral.double_I chi_E(x,y,z) dif x dif y)
     dif z \
  &= integral_a^b
     (integral.double_I chi_(E_z)(x,y) dif x dif y)
     dif z \
  &= integral_a^b |E_z| dif z.
$

Ta thu được công thức nói rằng #text(fill: rgb("#D96B19"), style: "italic")[thể tích của khối bằng tích phân của diện tích mặt cắt]:

$
  |E| = integral_a^b |E_z| dif z.
$
#align(right)[(4.20)]

Ở trung học [SGKPT, Giải tích 12] công thức này đã được phát biểu không chứng minh. Từ công thức này ta có thể thu được công thức tính thể tích của một số khối hay gặp, như khối cầu, khối lăng trụ, khối hình chóp, khối hình chóp cụt, xem các bài tập của mục này và các bài tập 4.41, 5.45.

#vidu[
  *4.21 Ví dụ* (#text(fill: rgb("#8766E8"), weight: "bold")[thể tích quả cầu]).

  Ta đã biết ở Ví dụ 3.12 là quả cầu có thể tích. Các mặt cắt vuông góc trục $z$, $-R <= z <= R$, của quả cầu $x^2 + y^2 + z^2 <= R^2$ là những miền phẳng bao bởi đường tròn $x^2 + y^2 = R^2 - z^2$, nên có diện tích bằng $pi (R^2 - z^2)$, vậy thể tích quả cầu bán kính $R$ bằng

  $
    integral_(-R)^R pi (R^2-z^2) dif z
    = (4 pi)/3 R^3.
  $

  Như vậy đây là một #text(fill: rgb("#D96B19"), style: "italic")[chứng minh] cho công thức thể tích quả cầu.
]

#vidu[
  *4.22 Ví dụ* (#text(fill: rgb("#8766E8"), weight: "bold")[thể tích khối tròn xoay]).

  Cho $f$ là hàm liên tục trên khoảng $[a,b]$ và $f(x) > 0$ trên $[a,b]$. Xét khối tròn xoay nhận được bằng cách xoay miền dưới đồ thị của $f$ quanh trục $x$.

  Mỗi mặt cắt của khối tròn xoay này với mặt phẳng vuông góc trục $x$ là một miền phẳng bao bởi đường tròn có tâm trên trục $x$ và bán kính là $f(x)$, vậy khối tròn xoay này gồm những điểm $(x,y,z)$ thỏa $a <= x <= b$ và $y^2 + z^2 <= f(x)^2$.

  Khối này có biên gồm hai miền phẳng bao bởi đường tròn và một mặt tròn xoay $a <= x <= b$, $y^2 + z^2 = f(x)^2$. Có thể xem mặt tròn xoay này là hội của hai đồ thị của hai hàm liên tục

  $
    z = sqrt(f(x)^2 - y^2)
  $

  và

  $
    z = -sqrt(f(x)^2 - y^2)
  $

  trên miền $a <= x <= b$, $|y| <= f(x)$. Nhờ đó ta thấy biên của khối tròn xoay có thể tích không, do đó khối tròn xoay có thể tích. Xem Hình 4.23.

  #align(center)[
    #image("Tong Hop Hinh/hinh 4-23.png", width: 75%)
  ]

  #align(center)[
    *Hình 4.23:* Khối tròn xoay và mặt cắt.
  ]

  Để tính thể tích ta áp dụng phương pháp cắt lớp ở Công thức (4.20). Khối tròn xoay này có mặt cắt tại mỗi $x$ là một hình tròn có bán kính là $f(x)$, có diện tích là $pi [f(x)]^2$. Vậy thể tích của khối tròn xoay nhận được bằng cách xoay miền dưới đồ thị của $f$ quanh trục $x$ bằng

  $
    integral_a^b pi [f(x)]^2 dif x.
  $

  Khối tròn xoay còn có thể được tạo ra bằng cách xoay quanh trục $y$, khi đó ta cần chỉnh công thức cho phù hợp.
]

#vidu[
  *4.24 Ví dụ.* #text(fill: rgb("#8766E8"), weight: "bold")[Nguyên lý Cavalieri] được phát biểu như sau: Nếu có một phương sao cho một mặt phẳng bất kì với phương đó cắt hai khối ba chiều theo hai mặt cắt có cùng diện tích thì hai khối đó có cùng thể tích. Xem Hình 4.25.

  #align(center)[
    #image("Tong Hop Hinh/hinh 4-25.png", width: 90%)
  ]

  #align(center)[
    *Hình 4.25:* Theo Nguyên lý Cavalieri, hai khối này có cùng thể tích vì hai mặt cắt ở cùng cao độ bất kì có cùng diện tích.
  ]

  Điều này đúng với giả thiết hai khối có thể tích và các mặt cắt vuông góc với cùng một trục tọa độ, rút ra ngay được từ Công thức (4.20).

  Trong lịch sử, Nguyên lý Cavalieri có trước tích phân, được dùng để rút ra một số công thức thể tích như thể tích của khối trụ và khối chóp, xem Bài tập 4.33, 4.35, [Vhhvp].
]

== Bài Tập

Các bài toán nào không yêu cầu kiểm tra các điều kiện để áp dụng các công thức thì người làm không cần trình bày. Để tính tích phân một biến có thể dùng máy tính. Nếu không tìm được giá trị đúng của tích phân thì có thể tính gần đúng.

#baitoan[
  *4.26.* Tính tích phân của hàm và giải thích cơ sở cho các tính toán.

  (a)
  $
    f(x,y) = cases(
      x^3 y & quad (x,y) in [0,1] times [0,2] without {(0,0)},
      2023 &quad (x,y) = (0,0).
    )
  $

  (b)
  $
    f: [0,1] times [0,1] -> RR
  $

  $
    (x,y) &mapsto f(x,y)
    = cases(
      x+y &quad x <= y,
      x y &quad x > y.
    )
  $

  (c)
  $
    f(x,y) = cases(
      x^2 y & quad 0 <= x <= 1"," 0 <= y <= 1"," y <= x^2,
      x y^2 & quad 0 <= x <= 1"," 0 <= y <= 1"," y > x^2.
    )
  $
]
#loigiai[


  *a)*
  Đặt $D={(x,y in RR^2) : 0<=x<=1 ,0<=y<=2}
  $, có $D$ đóng và bị chặn trong $RR^2$. Khi đó, có $f$ bị chặn trên $D$ và $f$ liên tục tại các điểm $(x,y) in RR^2 : (x,y)!=(0,0)$. Mặt khác, tập điểm không liên tục của $f$ là $D_f={(0,0)}$ suy ra , $V_(D_f)=0$. Do đó, $f$ khả tích. Và đặt $g=f$ xác định trên $I=D backslash D_f$. Vậy, ta có
  $
  integral_ D f=integral_I g =integral_(0)^1 (integral_0 ^2 x^3 y dif y ) dif x=integral_0^1 2x^3 dif x=1/2
  $
  Cơ sở tính toán để áp dụng công thức Fubini như trên là , $g$ liên tục.

  *b)* Đặt $D={(x,y) in RR^2 : 0<=x<=1 , 0<=y<=1} subset RR^2$. Khi đó, $D$ đóng và bị chặn trên $RR^2$. Hơn nữa, $partial D ={"Các đường thẳng trong R"} => V(partial(D))=0$. Do đó, $D$ có diện tích trong $RR^2$. Mặt khác, có $f$ bị chặn trên $D$ và tập các điểm không liên tục của $f$ là $D_f={(a,a) in RR^2 : 0<a<=1}=> V(D_f)=0$, vì hàm $f=x$ liên tục trên $[0,1]$, nên đồ thị hàm số $y=f(x)$, có diện tích không trong $RR^2 => V(D_f)=0$. Vậy, $f$ khả tích. Hơn nữa $D= D_1 union D_2$, với $D_1={(x,y) in RR^2 :0<=y<=1 ,0<=x<=y}$ và $D_2={(x,y) in RR^2 : 0<=x<=1, 0<=y<x}$. Khi đó, ta có $D_1 inter D_2= emptyset$, nên $
  integral_D f=integral_(D_1) f+integral_(D_2) f&=integral_0^1 (integral_0 ^ y (x+y) dif x)dif y+integral_0^1(integral_0^x (x y) dif y) dif x= 5/8
  $

  *c)* Đặt $D={(x,y )in RR^2 : 0<=x<=1,0<=y<=1}$. Thì ta có tập các điểm gián đoạn của $f$ là $D_f={(x,y) in RR^2 : y=x^2}$, dễ thấy hàm $f=x^2$ liên tục trên $[0,1]$ nên $f$ khả tích trên $[0,1]$, do đó $D_f$ có diện tích không.Mặt khác, luôn có $f$ bị chặn trên $D$, nên theo tiêu chuẩn khả tích thì $f$ khả tích trên $D$. Lại có $D=D_1 union D_2$, trong đó
  $
  D_1={(x,y) in RR^2 : 0<=x<=1 , x^2<=y<=1 } quad "và" quad D_2={(x,y) in RR^2 : 0<=y<=1,sqrt(y)<=x<=1} => D_1 inter D_2= emptyset
  $
  Do đó, 
  $
  integral_D f= integral_(D_1) f+ integral_(D_2) f=integral_0 ^1 (integral_(x^2)^1 x y^2 dif y) dif x+ integral_0^1 (integral_(sqrt(y))^1 x ^2 y dif x) dif y= 11/56
  $
  Cơ sở tính toán cho việc trên và áp dụng công thức Fubini là $f$ liên tục.
]
#baitoan[
  *4.27.* Hãy tính các tích phân sau. Hãy vẽ phác họa các hình liên quan để xác định tích phân. Kiểm điều kiện áp dụng các công thức.

  (a) Tính tích phân $integral.double_D x^2 y dif A$, với $D$ là hình chữ nhật $0 <= x <= 2$, $-1 <= y <= 2$.

  (b) Gọi $D$ là miền bao bởi các đường cong $y = x^2$ và $x = y^4$, hãy tính

  $
    integral.double_D (sqrt(x) - y^2) dif A.
  $

  (c) Gọi $D$ là miền được bao bởi các đường cong $x = y^2$, $y-x=3$, $y=-3$, $y=2$. Tính $integral.double_D x dif A$.

  (d) Gọi $D$ là miền trong góc phần tư thứ nhất, nằm bên trên đường hyperbol $x y=1$, bên trên đường thẳng $y=x$, bên dưới đường thẳng $y=2$. Tính $integral.double_D y dif A$.

  (e) Tính tích phân của hàm $1+x+y$ trên miền được bao bởi các đường $y=-x$, $x=sqrt(y)$, $y=2$.

  (f) Tính tích phân của hàm $x y$ trên hình tam giác với các đỉnh $(0,0)$, $(1,0)$, $(1,1)$.

  (g) Tính tích phân của hàm $x^2 y^3$ trên miền được bao bởi các đường $y=4x^2$, $y=5-sqrt(3)x^2$.
]
#loigiai[

  *a)* Có $f(x,y)=x^2 y$, do đó $f$ liên tục trên $RR^2$ và đặc biệt trên $D={(x,y) in RR^2 : 0<=x<=2,-1<=y<=2}$, suy ra $f$ khả tích trên $D$. Nên áp dụng công thức Fubini. Ta được $
  integral.double_ D f d A=integral_0^2(integral_(-1)^2 x^2 y dif y) dif x=4.
  $

  *b)* Tìm giao điểm của $2$ đường cong, ta được $(0,0)$ và $(1,1)$. Khi đó, ta có $D={(x,y) in RR^2: 0<=x<=1 ,x^2<=y<=x^(1/4)}$. Do đó, áp dụng công thức Fubini, ta có $
  integral_D (sqrt(x)-y^2) d A=integral_0^1 (integral_(x^2)^x^(1/4)(sqrt(x)-y^2)dif y) dif x=1/7
  

  
  $
  
  #figure(
    image("Tong Hop Hinh/hinh -bt-2.png",width: 25%),
  )
  *c)* Ta có minh họa D như sau :
  #figure(
    image("Tong Hop Hinh/hinh -bt-2d.png",width: 35%),
  )

  Khi đó, ta có thể thấy $D=D_1 union D_2 union D_3$, với $
  D_1={(x,y) in RR^2 :-6<=x<=-1,-3<=y<=x+3} union{(x,y) in RR^2 : -1<=x<=0,-3<=y<=2}, quad D_2={(x,y) in RR^2 :0<=y<=2,0<=x<=y^2}
  $
  Và 
  $
  D_3={(x,y) in RR^2 :0<=x<=9,-3<=y<=-sqrt(x)}.
  $ Hơn nữa , các miền $D_1,D_2,D_3$ đôi một rời nhau nên do đó
  $
  integral.double_D y d A= integral.double_D_1 y d A+integral.double_D_2 y d A+integral_D_3 y dif A=-425/12
  $
  Nếu xét đơn giản theo miền ngang, thì đơn giản $
  D={(x,y) in RR^2 : -3<=y<=2,y-3<=x<=y^2}.
  $

  
  *d)* Ta minh họa $D$ như sau
  #figure(
    image("Tong Hop Hinh/hinh -bt-2c.png",width: 35%),
  )
Khi đó, có tọa độ giao điểm của các đường cong là $(0.5,2),(1,1),(2,2)$. Ta tách $D$ thành hai miền $D_1$ và $D_2$, trong đó
$
D_1={(x,y)in RR^2 : 1/2<=x<=1,1/x<=y<=2} quad , D_2={(x,y) in RR^2: 1<=x<=2,x<=y<=2}. => D_1 inter D_2={(1,y) : 1<=y<=2}
$
Mà, $V(D_1 inter D_2)=0$
do đó, $
integral.double_D y=integral_(1/2)^1 (integral_(1/x)^2 y dif y )dif x + integral_1^2(integral_x^2 y dif y) dif x=4/3
 $
 

 *e)* Ta có minh họa $D$ như sau
 #figure(
   image("Tong Hop Hinh/hinh bt-5.png",width: 35%),
 )
 Dễ thấy, nếu đơn giản theo chiều ngang thì $
 D={(x,y) in RR^2 : 0<=y<=2 , -y<=x<=sqrt(y)}.
 $
 Do đó, áp dụng công thức Fubini, với $f=1+x+y$ liên tục trên $D$, nên đặc biệt khả tích. Suy ra,
 $
 integral_(0)^2 (integral_(-y)^(sqrt(y))1+x+y dif x) dif y =integral_0^2 sqrt(y)(y+1) +3/2 y +1/2 y^2 dif y=8.48
 $

 *f)* Dễ thấy, $
 D={(x,y) in RR^2 : 0<=x<=1 ,0<=y<=x}
 $
 Hơn nữa, ta có $f$ liên tục trên $RR^2$ nên đặc biệt liên tục trên $D$, do đó $f$ khả tích. Suy ra, áp dụng công thức Fubini, ta được
 $
 integral_0^1 (integral_0^x x y dif y) dif x=integral_0^1 x^3/2 dif x=1/8
 $
 *g)*
]
#baitoan[
  *4.28.* Hãy tính các tích phân sau bằng cách đổi thứ tự tích phân.

  (a)
  $
    integral_0^1
    (integral_(x^2)^1 x e^(-y^2) dif y) dif x.
  $

  (b)
  $
    integral_0^1
    (integral_(sqrt(y))^1 sqrt(x^3+2) dif x) dif y.
  $

  (c)
  $
    integral_0^1
    (integral_(3y)^3 cos(x^2) dif x) dif y.
  $

  (d)
  $
    integral_0^2
    (integral_(y^2)^4 y cos(x^2) dif x) dif y.
  $

  (e)
  $
    integral_0^1
    (integral_(sqrt(x))^1 e^(y^3) dif y) dif x.
  $

  (f) $integral.double_D (sin x)/x dif A$, trong đó $D$ là tam giác bao bởi trục $x$, đường $y=x$, và đường $x=1$.

  (g) $integral.double_D e^(y/x) dif A$, trong đó $D$ là tam giác bao bởi đường $y=x$, đường $y=0$, và đường $x=1$.
]

#loigiai[

  *a)* Đặt $D={(x,y) in RR^2 : 0<=x<=1, x^2<=y<=1}$. Khi đó, xét đơn giản theo chiều ngang, ta được $D={(x,y)in RR^2 : 0<=y<=1 , 0<=x<=sqrt(y)}$. Nên $
  I=integral_0 ^1 (integral_(0)^(sqrt(y)) x e ^(-y^2)dif x) dif y=(1-e^(-1))/4
  $

  *b)* Với $D={(x,y) in RR^2 : 0<=y<=1, sqrt(y)<=x<=1}$. Khi đó, xét đơn giản theo chiều dọc, ta được
  $
  D={(x,y)in RR^2: 0<=x<=1,0<=y<=x^2} => I=integral_0^1 (integral_(x^2)^1 sqrt(x^3+2) dif y) dif x=2/9 (3sqrt(3)- 2sqrt(2))
  $

  *c)* Có $D={(x,y) in RR^2 : 0<=y<=1, 3y<=x<=3}$. Khi đó, đơn giản theo chiều dọc ta được,
  $
  D={(x,y) in RR^2: 0<=x<=3, 0<=y<=x/3}
  $
  Do đó, $
  I=integral_0 ^ 3 (integral_0 ^ (x/3) cos(x^2)dif y) dif x=(sin 9)/6
  $
  *d)* Có $D={(x,y) in RR^2 : 0<=y<=2, y^2<=x<=4}$.Khi đó, đơn giản theo chiều ngang, ta được
  $
  D={(x,y)in RR^2: 0<=x<=4,0<=y<=sqrt(x)}.
  $
  Do đó, 
  $
  integral_0^4 (integral_0^(sqrt(x))y cos(x^2)dif y)dif x=sin(16)/4
  $

  *e)* Có $D={(x,y)in RR^2:0<=x<=1, sqrt(x)<=y<=1}$. Khi đó, xét đơn giản theo chiều ngang, ta được
  $
  D={(x,y)in RR^2: 0<=y<=1,0<=x<=y^2}
  $
  Suy ra,
  $
  I=integral_0^1 (integral_0 ^ (y^2) e^(y^2) dif x)dif y=(e-1)/3
  $
  *f)*
  Có $D={(x,y)in RR^2 : 0<=x<=1,0<=y<=x}$, tương tự các bài toán trên suy ra, $I=1-cos(1)$.

  *g)* Tương tự ý trên, ta thấy nếu đơn giản theo chiều dọc thì bài toán sẽ tính toán dễ hơn. Do đó, xét $D={(x,y) in RR^2: 0<=x<=1, 0<=y<=x} => I=(e-1)/2$.
  
]
#baitoan[
  *4.29.* Hãy tính các tích phân sau. Hãy vẽ phác họa các hình liên quan để xác định tích phân. Kiểm điều kiện áp dụng các công thức.

  (a) Tính thể tích của khối bên dưới mặt $z=4-x-y$ bên trên hình chữ nhật $0 <= x <= 1$, $1 <= y <= 2$.

  (b) Tính tích phân $integral.triple_E y dif V$ trong đó $E$ là khối tứ diện với 4 đỉnh $(0,0,0)$, $(1,0,0)$, $(2,1,0)$ và $(0,0,1)$.

  (c) Tính tích phân $integral.triple_E z dif V$ trong đó $E$ là khối được bao bởi các mặt $z=0$, $x=0$, $y=x$, $y=1$, $z=2x+3y$.

  (d) Tìm thể tích của khối được bao bởi các mặt $y=0$, $z=0$, $z=1-x+y$, $y=1-x^2$.

  (e) Tính thể tích của khối bên dưới đồ thị của hàm $z=y^2$ bên trên hình chữ nhật $0 <= x <= 1$, $-1 <= y <= 0$.

  (f) Tính thể tích của khối bao bởi các mặt $z=0$, $y+z=1$, $y=x^2$.

  (g) Tính thể tích của khối bao bởi các mặt $x=4-y^2$, $y+z=2$, $x=0$, $y=0$, $z=0$.

  (h) Tính thể tích của khối bao bởi các mặt $x^2+y^2=1$, $z=-y$, $z=0$.
]
#loigiai[

Các miền xét dưới đây đều bị chặn, có biên gồm hữu hạn mảnh mặt phẳng hoặc mặt cong liên tục thích hợp, nên có thể tích Jordan. Các hàm dưới dấu tích phân đều liên tục. Vì vậy, có thể áp dụng công thức tính tích phân bội ba bằng tích phân lặp.

*a)* Xét hình chữ nhật đáy

$ D = { (x,y) in RR^2 : 0 <= x <= 1, 1 <= y <= 2 }. $

Vì $4 - x - y >= 1 > 0$ trên $D$, khối cần xét là

$ Omega = { (x,y,z) : (x,y) in D, 0 <= z <= 4 - x - y }. $

Suy ra

$ V(Omega) &= integral.triple_Omega 1 dif V \
  &= integral_0^1 integral_1^2 integral_0^(4 - x - y) 1 dif z dif y dif x \
  &= integral_0^1 integral_1^2 (4 - x - y) dif y dif x \
  &= 2. $

*b)* Gọi $A=(1,0,0)$, $B=(2,1,0)$ và $C=(0,0,1)$. Mặt phẳng đi qua ba điểm $A,B,C$ có phương trình

$ z = 1 - x + y. $

Hình chiếu của tứ diện $E$ lên mặt phẳng $O x y$ là tam giác có ba đỉnh $(0,0)$, $(1,0)$, $(2,1)$. Do đó

$ D = { (x,y) in RR^2 : 0 <= y <= 1, 2 y <= x <= 1 + y }. $

Miền $E$ được mô tả bởi

$ 0 <= y <= 1, quad 2 y <= x <= 1 + y, quad 0 <= z <= 1 - x + y. $

Khi đó

$ integral.triple_E y dif V
  &= integral_0^1 integral_(2 y)^(1 + y) integral_0^(1 - x + y) y dif z dif x dif y \
  &= integral_0^1 integral_(2 y)^(1 + y) y (1 - x + y) dif x dif y \
  &= 1/2 integral_0^1 y (1 - y)^2 dif y \
  &= 1/24. $

*c)* Các mặt $x=0$, $y=x$ và $y=1$ giới hạn miền tam giác

$ D = { (x,y) in RR^2 : 0 <= y <= 1, 0 <= x <= y }. $

Do $2 x + 3 y >= 0$ trên $D$, khối $E$ được mô tả bởi

$ 0 <= y <= 1, quad 0 <= x <= y, quad 0 <= z <= 2 x + 3 y. $

Vì vậy

$ integral.triple_E z dif V
  &= integral_0^1 integral_0^y integral_0^(2 x + 3 y) z dif z dif x dif y \
  &= 1/2 integral_0^1 integral_0^y (2 x + 3 y)^2 dif x dif y \
  &= 1/2 integral_0^1 (49 y^3)/3 dif y \
  &= 49/24. $

*d)* Hai mặt $y=0$ và $y=1-x^2$ cắt nhau khi $x=-1$ hoặc $x=1$. Vì $1-x^2 >= 0$ với $-1 <= x <= 1$, miền đáy là

$ D = { (x,y) in RR^2 : -1 <= x <= 1, 0 <= y <= 1 - x^2 }. $

Trên miền này, $1 - x + y >= 0$. Vì thế, khối cần xét thỏa mãn

$ -1 <= x <= 1, quad 0 <= y <= 1 - x^2, quad 0 <= z <= 1 - x + y. $

Thể tích là

$ V &= integral_-1^1 integral_0^(1 - x^2) integral_0^(1 - x + y) 1 dif z dif y dif x \
  &= integral_-1^1 integral_0^(1 - x^2) (1 - x + y) dif y dif x \
  &= integral_-1^1 ((1 - x)(1 - x^2) + (1 - x^2)^2/2) dif x \
  &= 28/15. $

Ở bước cuối, dùng tính chất tích phân của hàm lẻ: $integral_(-1)^1 x (1-x^2) dif x = 0$.

*e)* Khối nằm dưới mặt $z=y^2$ và phía trên hình chữ nhật $0 <= x <= 1$, $-1 <= y <= 0$ được cho bởi

$ 0 <= x <= 1, quad -1 <= y <= 0, quad 0 <= z <= y^2. $

Do đó

$ V &= integral_0^1 integral_(-1)^0 integral_0^(y^2) 1 dif z dif y dif x \
  &= integral_0^1 integral_(-1)^0 y^2 dif y dif x \
  &= 1/3. $

*f)* Từ $z=0$ và $y+z=1$ suy ra $0 <= z <= 1-y$. Mặt $y=x^2$ cắt mặt $y=1$ theo $x=-1$ và $x=1$. Do đó, miền đáy là

$ D = { (x,y) in RR^2 : -1 <= x <= 1, x^2 <= y <= 1 }. $

Khối cần xét được mô tả bởi

$ -1 <= x <= 1, quad x^2 <= y <= 1, quad 0 <= z <= 1 - y. $

Suy ra

$ V &= integral_(-1)^1 integral_(x^2)^1 integral_0^(1 - y) 1 dif z dif y dif x \
  &= integral_(-1)^1 integral_(x^2)^1 (1 - y) dif y dif x \
  &= 1/2 integral_(-1)^1 (1 - x^2)^2 dif x \
  &= 8/15. $

*g)* Các mặt $x=0$, $y=0$, $z=0$ giới hạn khối trong góc phần tám thứ nhất. Từ $x=4-y^2 >= 0$ và $z=2-y >= 0$, suy ra $0 <= y <= 2$. Khi đó

$ 0 <= y <= 2, quad 0 <= x <= 4 - y^2, quad 0 <= z <= 2 - y. $

Vì vậy

$ V &= integral_0^2 integral_0^(4 - y^2) integral_0^(2 - y) 1 dif z dif x dif y \
  &= integral_0^2 (4 - y^2)(2 - y) dif y \
  &= integral_0^2 (8 - 4 y - 2 y^2 + y^3) dif y \
  &= 20/3. $

*h)* Mặt trụ $x^2+y^2=1$ giới hạn hình tròn đáy $x^2+y^2 <= 1$. Xét phần khối nằm phía trên mặt $z=0$. Vì $0 <= z <= -y$ nên $y <= 0$.

Hình chiếu của khối lên mặt phẳng $O x y$ là nửa hình tròn

$ D = { (x,y) in RR^2 : -1 <= x <= 1, -sqrt(1 - x^2) <= y <= 0 }. $

Do đó

$ V &= integral_-1^1 integral_(-sqrt(1 - x^2))^0 integral_0^(-y) 1 dif z dif y dif x \
  &= integral_-1^1 integral_(-sqrt(1 - x^2))^0 (-y) dif y dif x \
  &= 1/2 integral_-1^1 (1 - x^2) dif x \
  &= 2/3. $

Nếu xét phần khối nằm dưới mặt $z=0$, ta có $y >= 0$ và $-y <= z <= 0$. Hai phần khối đối xứng qua phép đổi dấu $(y,z)$ nên có cùng thể tích $2/3$.
  
]
#baitoan[
  *4.30.* Dùng phương pháp cắt lớp, hãy tìm công thức thể tích của:

  (a) Hình lăng trụ, xem Hình 3.27 trang 37.

  (b) Hình nhận được bằng cách xoay phần bên dưới đường $y=sqrt(x)$, $0 <= x <= 4$, quanh trục $x$.

  (c) Hình nhận được bằng cách xoay phần giữa đường $y=sqrt(x)$ và đường $y=1$, $1 <= x <= 4$, quanh trục $y=1$.

  (d) Hình nhận được bằng cách xoay phần giữa đường $x=2/y$ và trục $y$, $1 <= y <= 2$, quanh trục $y$.

  (e) Hình nhận được bằng cách xoay phần giữa đường $x=y^2+1$ và đường $x=3$, quanh trục $x=3$.

  (f) Hình nhận được bằng cách xoay phần giữa đường $y=x^2+1$ và đường $y=-x+3$, quanh trục $x$.

  (g) Hình nhận được bằng cách xoay phần giữa đường $y=x^2$ và đường $y=2x$, $x >= 0$, quanh trục $y$.
]

#loigiai[

  *a)* Đối với hình lăng trụ có chiều cao $h$, cắt hình trụ bằng những mặt $z$, thì $S(z)=S$ không đổi. Do đó, 
  $
  V=integral_0^h S dif z = S h 
  $

  *b)* Vì trục quay là Ox, ta cắt theo phương vuông góc với Ox, với mỗi $x in [0,4]$, mặt cắt ta thu được là hình tròn có bán kính $sqrt(x)$, do đó
  $
  V=integral_0^4 pi x dif x=8 pi
  $

  *c)* Vì trục quay là $y=1$, ta cắt theo phương vuông góc với Oy, khi đó với mỗi $x in [1,4]$, mặt cắt ta thu được là hình tròn có bán kính $sqrt(x)-1$, vì khoảng cách từ điểm thuộc $y=sqrt(x) -> y=1$ là $y=sqrt(x)-1$. Do đó,
  $
  V=integral_1^4 pi (sqrt(x)-1)^2 dif x=(7pi)/6
  $

  *d)* Vì trục quay là Oy, ta cắt theo phương vuông góc với Oy, khi đó với mỗi $y in [1,2]$, mặt cắt ta thu được là hình tròn có bán kính $2/y$. Do đó,
  $
  V=integral_1^2 pi (2/y)^2 dif y=2 pi
  $
  *e)* Từ $x=y^2+1$ và $x=3 => y=-sqrt(2) or y=sqrt(2)$. Mặt khác, vì trục quay là $x=3$, ta cắt theo phương vuông góc với Oy, và với mỗi $y in [-sqrt(2),sqrt(2)]$ ta được mặt cắt là hình tròn có bán kính $3-y^2-1$. Do đó,
  $
  V=integral_(-sqrt(2))^sqrt(2) pi (2-y^2)^2 dif y=(64 sqrt(2) pi)/15
  $

  *f)* Từ $y=x^2+1$ và $y=-x+3$, khi đó ta có giao điểm của $2$ đường là $x=-2 or x=1$, hơn nữa trên đoạn $[-2,1]$ ta luôn có $y=x^2+1 <= -x+3$.Với trục quay là Ox, ta cắt theo phương vuông góc với Ox, ta thu được $2$ hình tròn với bán kính hình trong là $-x+3$ và bán kính ngoài là $x^2+1$. Suy ra,
  $
  V=integral_(-2)^1 pi [(3-x)^2-(x^2+1)^2] dif x=(117 pi)/5
  $

  *g)* Từ $y=x^2$ và $y=2x$, ta có tọa độ giao điểm của $2$ đường trên là $(0,0)$ và $(0,4)$. Với trục quay là Oy, ta cắt theo phương vuông góc với Oy, hơn nữa với mỗi $y in [0,4]$ thì $sqrt(y)<=y/2$. Do đó khi cắt, ta thu được $2$ hình tròn lần lượt có bán kính trong và ngoài là $ R_1=y/2$ và $R_2=sqrt(y)$.Vậy,
  $
  V=integral_0^4 pi [y^2/4 - y]dif y=(8pi)/3
  $
  
  
]
#baitoan[
  *4.31.* Tính thể tích của khối được miêu tả trong Hình 4.32.

  #align(center)[
    #image("Tong Hop Hinh/hinh 4-32.png", width: 65%)
  ]

  #align(center)[*Hình 4.32*]
]

#loigiai[
  Từ Hình 4.32, khối $Omega$ được giới hạn bởi các mặt
  $x = 0$, $x = 1$, $z = 0$, $z = e^(3 x)$,
  $y = -e^x$ và $y = e^(2 x)$.

  Hình chiếu của khối $Omega$ xuống mặt phẳng $O x y$ là miền

  $ D = { (x,y) in RR^2 : 0 <= x <= 1,
    -e^x <= y <= e^(2 x) }. $

  Vì $e^(3 x) > 0$ với mọi $x in [0,1]$, nên

  $ Omega = { (x,y,z) in RR^3 :
    (x,y) in D, 0 <= z <= e^(3 x) }. $

  Các hàm xác định cận đều liên tục trên $[0,1]$,
  nên có thể áp dụng công thức Fubini.

  Do đó, thể tích khối $Omega$ là

  $
    V(Omega)
    &= integral.triple_Omega 1 dif V \
    &= integral_0^1 integral_(-e^x)^(e^(2 x))
       integral_0^(e^(3 x)) 1 dif z dif y dif x \
    &= integral_0^1 integral_(-e^x)^(e^(2 x))
       e^(3 x) dif y dif x \
    &= integral_0^1 e^(3 x) (e^(2 x) + e^x) dif x \
    &= integral_0^1 (e^(5 x) + e^(4 x)) dif x \
    &= (e^5 - 1)/5 + (e^4 - 1)/4 \
    &= (4 e^5 + 5 e^4 - 9)/20.
  $
  * Cách Khác *
  Xét mặt phẳng $x = t$ với $0 <= t <= 1$,
  vuông góc với trục $O x$.

  Khi đó, thiết diện của khối $Omega$ bởi
  mặt phẳng $x = t$ là hình chữ nhật
  được giới hạn bởi

  $
    cases(
      -e^t <= y <= e^(2 t),
      0 <= z <= e^(3 t)
    ).
  $

  Do đó, diện tích thiết diện là

  $
    S(t) &= (e^(2 t) + e^t) e^(3 t) \
         &= e^(5 t) + e^(4 t).
  $

  Theo công thức tính thể tích qua diện tích
  thiết diện, ta có

  $
    V(Omega)
    &= integral_0^1 S(t) dif t \
    &= integral_0^1 (e^(5 t) + e^(4 t)) dif t \
    &= [e^(5 t)/5 + e^(4 t)/4]_0^1 \
    &= (4 e^5 + 5 e^4 - 9)/20.
  $
]
#baitoan[
  *4.33.* Dùng Nguyên lý Cavalieri, Ví dụ 4.24, chứng tỏ rằng thể tích của khối trụ nghiêng bao bởi mặt $x^2 + (y-z-3)^2 = 1$, $0 <= z <= 1$ bằng với thể tích của khối trụ đứng bao bởi mặt $x^2+y^2=1$, $0 <= z <= 1$ (Hình 4.34).

  #align(center)[
    #image("Tong Hop Hinh/hinh 4-34.png", width: 75%)
  ]

  #align(center)[
    *Hình 4.34:* Mặt $x^2+y^2=1$ (trái) và mặt $x^2+(y-z-3)^2=1$ (phải).
  ]
]

#loigiai[
  Gọi $Omega_1, Omega_2$ lần lượt là khối trụ đứng và khối trụ nghiêng.

  Xét mặt phẳng $z = t$, với $t in [0,1]$.

  *Đối với khối trụ đứng:* Thiết diện của $Omega_1$ bởi mặt phẳng $z = t$ được xác định bởi

  $ x^2 + y^2 <= 1. $

  Đây là hình tròn bán kính $1$, nên diện tích thiết diện là

  $ S_1(t) = pi. $

  *Đối với khối trụ nghiêng:* Thiết diện của $Omega_2$ bởi mặt phẳng $z = t$ được xác định bởi

  $ x^2 + (y - t - 3)^2 <= 1. $

  Đây cũng là hình tròn bán kính $1$, nên diện tích thiết diện là

  $ S_2(t) = pi. $

  Như vậy, với mọi $t in [0,1]$, ta có

  $ S_1(t) = S_2(t) = pi. $

  Theo Nguyên lý Cavalieri, suy ra

  $ V(Omega_1) = V(Omega_2). $

  Hơn nữa,

  $
    V(Omega_1)
    &= V(Omega_2) \
    &= integral_0^1 pi dif t \
    &= pi.
  $
]

#baitoan[
  *4.35* (#text(fill: rgb("#8766E8"), weight: "bold")[lý luận của Archimedes tìm thể tích quả cầu]).

  Ở Hình 4.36, xét nửa trên quả cầu đơn vị bên trái, và khối nằm giữa hình trụ với hình chóp bên phải. Ở cùng cao độ $z$, mặt cắt bên phải là một hình tròn, còn mặt cắt bên trái là hình khuyên nằm giữa đường tròn bán kính $1$ và đường tròn bán kính $z$.

  (a) Dùng Nguyên lý Cavalieri, Ví dụ 4.24, chứng tỏ hai khối này có cùng thể tích.

  #align(center)[
    #image("Tong Hop Hinh/hinh 4-36.png", width: 90%)
  ]

  #align(center)[
    *Hình 4.36:* Tính thể tích quả cầu: nửa quả cầu bên trái và khối bên phải nằm giữa hình trụ và hình nón có cùng diện tích mặt cắt, nên có cùng thể tích, theo Nguyên lý Cavalieri.
  ]

  (b) Thể tích của khối bên phải bằng thể tích của khối trụ trừ thể tích của khối nón, từ đó hãy rút ra thể tích quả cầu đơn vị.
]

#baitoan[
  *4.37.* Cho $f$ là hàm liên tục, hãy viết lại tích phân

  $
    integral_(-1)^1
    integral_(abs(x))^1
    integral_0^(1-y)
    f(x,y,z) dif z dif y dif x
  $

  theo thứ tự $dif x dif z dif y$.
]

#loigiai[
  Miền lấy tích phân được xác định bởi

  $
    D = { (x,y,z) in RR^3 :
      -1 <= x <= 1,
      abs(x) <= y <= 1,
      0 <= z <= 1-y
    }.
  $

  Từ $abs(x) <= y <= 1$, suy ra

  $
    0 <= y <= 1, quad -y <= x <= y.
  $

  Do đó, ta có thể viết lại miền $D$ dưới dạng

  $
    D = { (x,y,z) in RR^3 :
      0 <= y <= 1,
      0 <= z <= 1-y,
      -y <= x <= y
    }.
  $

  Vì $f$ liên tục trên $D$, theo định lý Fubini,
  ta có

  $
    I
    &= integral_(-1)^1 integral_(abs(x))^1
       integral_0^(1-y) f(x,y,z)
       dif z dif y dif x \
    &= integral_0^1 integral_0^(1-y)
       integral_(-y)^y f(x,y,z)
       dif x dif z dif y.
  $
]

#baitoan[
  *4.38.* Tính

  $
    integral_0^2
    integral_0^1
    integral_(z^2)^4
    x^3 z cos(y^2) dif y dif x dif z.
  $
]
#loigiai[

  Đặt $Omega={(x,y,z) in RR^3 : 0<=z<=2,0<=x<=1,z^2<=y<=4}$. Khi đó, do các cận đều liên tục và ta có $0<=z<=2,z^2<=y<=4$ thì ta có $0<=y<=4 "và" 0<=z<=sqrt(y)$. Do đó, $Omega={(x,y,z)in RR^3 : 0<=x<=1 , 0<=y<=4 , 0<=z<=sqrt(y)}$. Vì hàm lấy tích phân và các cận đều liên tục, do đó áp dụng công thức Fubini, ta có
  $
  integral_0^2 integral_0^1 integral_(x^2)^4 x^3 z cos(y^2) dif y dif x dif z=integral_0^1 integral_0^4 integral_0^(sqrt(y)) x^3 cos(y^2) z dif z dif y dif x&=integral_0^1integral_0^4 x^3 cos(y^2) y/2 dif y dif x\
  &=sin(16)/16
  $
]
#baitoan[
  *4.39.* Cho $f$ liên tục trên đoạn $[a,b]$, cho $g$ liên tục trên đoạn $[c,d]$, chứng tỏ

  $
    integral.double_([a,b] times [c,d])
    f(x)g(y) dif x dif y
    = integral_a^b f(x) dif x
    times integral_c^d g(y) dif y.
  $
]
#loigiai[

  Ta chứng minh $
  integral.double_([a,b]times[c,d]) f(x) g(y) dif x dif y=integral_a^b f(x) dif x times integral_c^d g(y) dif y
  $
  Với $f$ là hàm liên tục trên $[a,b]$ và $g$ là hàm liên tục trên $[c,d]$, do đó áp dụng công thức Fubini,ta có
  $
  integral_a^b f(x) (integral_c^d g(x) dif y) dif x=integral_a^b f(x) dif x times integral_c^d g(y) dif y.
  $
]

#baitoan[
  *4.40.* Cho $g$ liên tục trên hình hộp $[a,b] times [c,d] times [e,f]$, chứng tỏ

  $
    integral.triple_([a,b] times [c,d] times [e,f])
    g(x,y,z) dif V
    = integral_a^b
    (integral_c^d
    (integral_e^f g(x,y,z) dif z)
    dif y) dif x.
  $
]

#loigiai[
  Đặt $D = [a,b] times [c,d] times [e,f]$.

  Vì $g$ liên tục trên tập compact $D$, nên $g$
  khả tích Riemann trên $D$.

  Xét các phân hoạch

  $
    P_x &: a = x_0 < x_1 < dots < x_n = b, \
    P_y &: c = y_0 < y_1 < dots < y_m = d, \
    P_z &: e = z_0 < z_1 < dots < z_p = f.
  $

  Đặt

  $
    D_(i j k) = [x_(i-1),x_i] times
    [y_(j-1),y_j] times [z_(k-1),z_k].
  $

  Vì $g$ liên tục trên $D_(i j k)$ nên tồn tại

  $
    m_(i j k) = min_(D_(i j k)) g, quad
    M_(i j k) = max_(D_(i j k)) g.
  $

  Khi đó, với mọi $(x,y,z) in D_(i j k)$, ta có

  $
    m_(i j k) <= g(x,y,z) <= M_(i j k).
  $

  Cố định $(x,y) in
  [x_(i-1),x_i] times [y_(j-1),y_j]$.

  Lấy tích phân theo $z$ trên $[z_(k-1),z_k]$,
  ta được

  $
    m_(i j k) Delta z_k
    <= integral_(z_(k-1))^(z_k)
       g(x,y,z) dif z
    <= M_(i j k) Delta z_k.
  $

  Cộng theo $k$, suy ra

  $
    sum_(k=1)^p m_(i j k) Delta z_k
    <= integral_e^f g(x,y,z) dif z
    <= sum_(k=1)^p M_(i j k) Delta z_k.
  $

  Tiếp tục lấy tích phân theo $y$ trên
  $[y_(j-1),y_j]$, rồi theo $x$ trên
  $[x_(i-1),x_i]$, ta được

  $
    sum_(k=1)^p m_(i j k)
    Delta x_i Delta y_j Delta z_k
    &<= integral_(x_(i-1))^(x_i)
        integral_(y_(j-1))^(y_j)
        integral_e^f g(x,y,z)
        dif z dif y dif x \
    &<= sum_(k=1)^p M_(i j k)
        Delta x_i Delta y_j Delta z_k.
  $

  Cộng theo $i,j$, suy ra

  $
    L(P,g)
    <= integral_a^b integral_c^d integral_e^f
       g(x,y,z) dif z dif y dif x
    <= U(P,g).
  $

  Mặt khác, do $g$ liên tục trên $D$, nên
  khi độ mịn của phân hoạch tiến về $0$, ta có

  $
    lim_(lambda(P) -> 0) L(P,g)
    = lim_(lambda(P) -> 0) U(P,g)
    = integral.triple_D g(x,y,z) dif V.
  $

  Theo định lý kẹp, suy ra

  $
    integral.triple_D g(x,y,z) dif V
    = integral_a^b integral_c^d integral_e^f
      g(x,y,z) dif z dif y dif x.
  $

  Vậy ta có điều phải chứng minh.
  
  *Cách Khác*
   Đặt $D = [a,b] times [c,d] times [e,f]$.

  Với mỗi $t in [a,b]$, đặt

  $
    H(t) = integral_c^d integral_e^f
    g(t,y,z) dif z dif y.
  $

  Ta sẽ chứng minh

  $
    integral.triple_D g(x,y,z) dif V
    = integral_a^b H(t) dif t.
  $

  *Bước 1.* Xét hàm số

  $
    F(t) = integral.triple_([a,t] times [c,d] times [e,f])
    g(x,y,z) dif V,
    quad t in [a,b].
  $

  Với $h > 0$ đủ nhỏ, theo tính cộng được của tích phân, ta có

  $
    F(t+h) - F(t)
    = integral.triple_([t,t+h] times [c,d] times [e,f])
    g(x,y,z) dif V.
  $

  Vì $g$ liên tục trên tập compact $D$ nên $g$ liên tục đều trên $D$.

  Do đó, với mọi $epsilon > 0$, tồn tại $delta > 0$ sao cho với mọi $(x,y,z), (t,y,z) in D$, nếu $abs(x-t) < delta$ thì

  $
    abs(g(x,y,z) - g(t,y,z)) < epsilon.
  $

  Suy ra

  $
    g(t,y,z) - epsilon
    <= g(x,y,z)
    <= g(t,y,z) + epsilon.
  $

  Lấy tích phân trên khối $[t,t+h] times [c,d] times [e,f]$, với $0 < h < delta$, ta được

  $
    h H(t) - epsilon h A
    &<= F(t+h) - F(t) \
    &<= h H(t) + epsilon h A,
  $

  trong đó $A = (d-c)(f-e)$.

  Ở đây, ta đã sử dụng tính chất tích phân đối với hàm không phụ thuộc vào biến $x$:

  $
    integral.triple_([t,t+h] times [c,d] times [e,f])
    g(t,y,z) dif V
    = h H(t).
  $

  *Bước 2.* Chia các vế của bất đẳng thức trên cho $h > 0$, ta được

  $
    H(t) - epsilon A
    <= (F(t+h) - F(t))/h
    <= H(t) + epsilon A.
  $

  Vì $epsilon > 0$ tùy ý, theo định lý kẹp, suy ra

  $
    lim_(h -> 0^+) (F(t+h) - F(t))/h
    = H(t).
  $

  Tương tự, với $h < 0$, ta cũng thu được

  $
    lim_(h -> 0^-) (F(t+h) - F(t))/h
    = H(t).
  $

  Do đó,

  $
    F'(t) = H(t), quad
    forall t in (a,b).
  $

  *Bước 3.* Vì $g$ liên tục trên $D$ nên $H$ liên tục trên $[a,b]$.

  Theo định lý Newton–Leibniz, ta có

  $
    F(b) - F(a)
    = integral_a^b H(t) dif t.
  $

  Mặt khác,

  $
    F(a) = 0, quad
    F(b) = integral.triple_D g(x,y,z) dif V.
  $

  Do đó,

  $
    integral.triple_D g(x,y,z) dif V
    &= integral_a^b H(t) dif t \
    &= integral_a^b
       (integral_c^d integral_e^f
       g(t,y,z) dif z dif y) dif t \
    &= integral_a^b integral_c^d integral_e^f
       g(x,y,z) dif z dif y dif x.
  $

  Vậy ta có điều phải chứng minh.
  
]

#baitoan[
  *4.41* (#text(fill: rgb("#8766E8"), weight: "bold")[thể tích của khối lăng trụ tổng quát]).

  Giả sử $D$ là một miền trong mặt phẳng $O x y$. Cho $v$ là một vectơ của $RR^3$ không nằm trong mặt phẳng $O x y$. Tập hợp tất cả các điểm có dạng $p+t v$ với $p in D$, $0 <= t <= 1$, được gọi là một khối lăng trụ. Miền $D$ được gọi là đáy của khối lăng trụ, còn khoảng cách từ $v$ tới mặt phẳng $O x y$ được gọi là chiều cao của khối lăng trụ. Xem Hình 4.42.

  #align(center)[
    #image("Tong Hop Hinh/hinh 4-42.png", width: 70%)
  ]

  #align(center)[*Hình 4.42:* Khối lăng trụ.]

  Ta chứng tỏ thể tích của khối lăng trụ đúng bằng diện tích đáy nhân chiều cao.

  (a) \* Chứng tỏ nếu đáy có diện tích thì khối lăng trụ có thể tích.

  (b) Dùng phương pháp cắt lớp để tính thể tích khối lăng trụ.
]

#baitoan[
  *4.43.* \* Cho $f: RR^2 -> RR$ khả vi liên tục cấp hai (tức là các đạo hàm riêng tới cấp hai tồn tại và liên tục).

  (a) Trên hình chữ nhật $[a,b] times [c,d]$ bất kì, dùng Công thức Fubini, hãy chứng tỏ

  $
    integral.double_([a,b] times [c,d])
    (partial^2 f)/(partial x partial y) dif A
    =
    integral.double_([a,b] times [c,d])
    (partial^2 f)/(partial y partial x) dif A.
  $

  (b) Dùng phần (a), chứng tỏ

  $
    (partial^2 f)/(partial x partial y)
    =
    (partial^2 f)/(partial y partial x).
  $

  Đây là một chứng minh dùng tích phân bội cho một kết quả thường dùng trong Vi phân hàm nhiều biến nói rằng nếu hàm khả vi liên tục cấp hai thì thứ tự lấy đạo hàm riêng không ảnh hưởng tới kết quả.
]
#pagebreak()

= Tuần 5
== Công Thức Đổi Biến


#pagebreak()

= Đề Thi Giữa Kỳ
== 2009-2010
#cau[
  *Bài 1 (1 điểm):* Phát biểu công thức đổi biến.
]

#cau[
  *Bài 2 (3 điểm):* Tính tích phân
  $
    integral.double_D y dif A,
  $
  trong đó $D$ là miền trong góc phần tư thứ nhất, nằm bên trên đường hyperbola $x y = 1$, bên trên đường thẳng $y = x$ và bên dưới đường thẳng $y = 2$.
]

#cau[
  *Bài 3 (3 điểm):* Tính tích phân
  $
    integral.triple_E x dif V,
  $
  với $E$ là khối tứ diện có 4 đỉnh $(0,0,0)$, $(1,0,0)$, $(0,1,0)$ và $(0,0,1)$.
]

#cau[
  *Bài 4 (2 điểm):* Tính tích phân
  $
    integral.double_D (x^2 + y^2)^(3/2) dif A,
  $
  với $D$ là miền trong góc phần tư thứ nhất bao bởi đường tròn $x^2 + y^2 = 9$, đường thẳng $y = 0$ và $y = sqrt(3) x$.
]

#cau[
  *Bài 5 (1 điểm):* Điều sau đây là đúng hay sai? Giải thích.
  $
    integral.double_([0,1] times [1,4])
    (x^2 + sqrt(y)) sin(x y^2) dif A = 10
  $
]
#pagebreak()
== 2010-2011
#cau[
  *Bài 1 (3 điểm):* Cho tích phân lặp:
  $
    integral_0^1 (integral_x^1 e^(x/y) dif y) dif x
  $

  a) Viết lại tích phân trên dưới dạng một tích phân bội.

  b) Tính tích phân trên bằng cách đổi thứ tự tích phân lặp.
]

#cau[
  *Bài 2 (3 điểm):* Gọi $E$ là khối được bao bởi các mặt phẳng
  $x = 0$, $y = 0$, $z = 0$, $2x + 2y + z = 4$.
  Hãy tính tích phân:
  $
    integral.triple_E y dif V
  $
]

#cau[
  *Bài 3 (3 điểm):* Gọi $E$ là khối được bao phía trên bởi
  mặt cầu $x^2 + y^2 + z^2 = 2$ và được bao phía dưới
  bởi mặt paraboloid $z = x^2 + y^2$.

  a) Chứng tỏ phần giao của hai mặt trên là một đường tròn.

  b) Tính thể tích của khối $E$.
]

#cau[
  *Bài 4 (1 điểm):* Trong mặt phẳng $RR^2$, một phép quay
  quanh gốc tọa độ một góc $alpha$ có thể được miêu tả
  như sau: Trong tọa độ cực, đó là ánh xạ
  $(r, theta) arrow.r.bar (r, theta + alpha)$.
  Trong tọa độ Euclid, đó là ánh xạ:
  $
    mat(x; y) arrow.r.bar
    mat(
      cos alpha, -sin alpha;
      sin alpha, cos alpha
    ) dot mat(x; y)
  $

  Hãy chứng tỏ một phép quay quanh gốc tọa độ mang
  một hình có diện tích thành một hình có cùng diện tích.
]#v(1em)
#line(length: 100%, stroke: 0.8pt)
#v(0.8em)

#align(center)[
  #text(size: 10pt, weight: "bold")[
    _HƯỚNG DẪN GIẢI_
  ]
]
#loigiai[

  *Câu 1*

  *a)* Xét tích phân lặp 
  $
  integral_0^1 (integral_x ^ 1 e ^(x/y) dif y) dif x quad (1)
  $
  Do đó, với $0<=z<=e^(x/y)$, ta có (1) tương đương
  $
  integral_0 ^1 integral_x ^1 (integral_0 ^(e^(x/y))1 dif z) dif y dif x
  $

  *b)* Từ giả thiết, ta có miền $D$ là
  $
  D={(x,y) in RR^2 : 0<=x<=1,x<=y<=1}.
  $
  Do đó, nếu đơn giản theo chiều ngang, ta được
  $
  D={(x,y) in RR^2 : 0<=y<=1, 0<=x<=y}.
  $
  Suy ra, $(1)$ tương đương
  $
  integral_0 ^ 1 integral_0 ^ y (e^(x/y)) dif x dif y=integral_0 ^1 (y e^(x/y)) |_0^y=integral_0^1 y e - y dif y=(e-1) y^2/2 | _0^1 = 1/2(e-1).
  $

  *Câu 2* Xét giao của $2$ mặt phẳng $z=0 "và" z=4-2 x -2 y$, ta được $y=2-x$, do đó, nếu chiếu $E$ xuống $O x y$, ta thu được miền $D$ như sau
  $
  D={(x,y) in RR^2 : 0<=x<=2,0<=y<=2-x}
  $
  Suy ra,
  $
  E={(x,y,z) in RR^3 : 0<=x<=2,0<=y<=2-x,0<=z<=4-2x-2 y }
  $
  Vậy,
  $
  integral.triple_E y dif V=integral_0 ^2 integral_0 ^(2-x) integral_0 ^(4-2x-2y) y dif z dif y dif x&=integral_0 ^2 integral_0 ^(2-x) y(4- 2x-2y)dif y dif x\
  &=integral_0^2 integral_0 ^(2-x) 4 y - 2 x y -2 y^2 dif y dif x\
  &=integral_0 ^2 (2 y^2 -x y^2-2/3 y^3 |_0 ^(2-x))\
  &=integral_0 ^2 (2(2-x)^2-x(2-x)^2-2/3(2-x)^3)dif x=4/3
  $

  *Câu 3*

  Ta có, hình minh họa khối $E$
#figure(
  image("Tong Hop Hinh/hinh 2010--.jpg",width: 35%),
)
  
  *a)* Thay $z=x^2+y^2$ vào $x^2+y^2+z^2=2$, ta được $z^2+z-2=0 <=> z=1 "hoặc "z=-2$, vì $z>=0$, nên $z=1$. Do đó, $x^2+y^2=1$ hay phần giao của $2$ mặt trên là đường tròn.

  *b)*
   *b) Tính thể tích của khối $E$.*

  *Cách 1. Sử dụng tích phân kép và tọa độ cực.*

  Mặt cầu phía trên có phương trình
  $
    z = sqrt(2 - x^2 - y^2).
  $

  Mặt paraboloid phía dưới có phương trình
  $
    z = x^2 + y^2.
  $

  Chiếu khối $E$ xuống mặt phẳng $O x y$, ta được miền
  $
    D = {(x,y) in RR^2 : x^2 + y^2 <= 1}.
  $

  Khi đó, thể tích của khối $E$ là
  $
    V(E)
    = integral.double_D
    (sqrt(2 - x^2 - y^2) - x^2 - y^2)
    dif x dif y.
  $

  Đổi sang tọa độ cực
  $
    cases(
      x = r cos phi,
      y = r sin phi,
    )
    quad
    cases(
      0 <= r <= 1,
      0 <= phi <= 2 pi.
    )
  $

  Ta có
  $
    V(E)
    &= integral_0^(2 pi) integral_0^1
    (sqrt(2-r^2) - r^2) r dif r dif phi \
    &= 2 pi integral_0^1
    (r sqrt(2-r^2) - r^3) dif r \
    &= 2 pi
    (integral_0^1 r sqrt(2-r^2) dif r
    - integral_0^1 r^3 dif r).
  $

  Mặt khác,
  $
    integral_0^1 r sqrt(2-r^2) dif r
    &= [(-frac((2-r^2)^(3/2),3)]_0^1) \
    &= frac(2 sqrt(2)-1,3).
  $

  Và
  $
    integral_0^1 r^3 dif r
    = [(frac(r^4,4))]_0^1
    = frac(1,4).
  $

  Suy ra
  $
    V(E)
    &= 2 pi (frac(2 sqrt(2)-1,3)-frac(1,4)) \
  $

  *Cách 2. Sử dụng diện tích mặt cắt ngang.*

  Xét mặt phẳng $z = t$ song song với mặt phẳng $O x y$.

  Do khối $E$ nằm phía trên mặt paraboloid và phía dưới mặt cầu nên
  $
    cases(
      x^2+y^2 <= t,
      x^2+y^2 <= 2-t^2.
    )
  $

  Suy ra mặt cắt ngang của khối $E$ tại độ cao $t$ là một hình tròn có bán kính bình phương bằng
  $
    R^2(t) = min(t, 2-t^2).
  $

  Ta có
  $
    t = 2-t^2
    <=> (t-1)(t+2) = 0.
  $

  Vì $t >= 0$ nên hai biểu thức bằng nhau tại $t = 1$.

  Khi $0 <= t <= 1$, ta có
  $
    t <= 2-t^2.
  $

  Do đó, diện tích mặt cắt là
  $
    S(t) = pi t.
  $

  Khi $1 <= t <= sqrt(2)$, ta có
  $
    2-t^2 <= t.
  $

  Do đó, diện tích mặt cắt là
  $
    S(t) = pi(2-t^2).
  $

  Vậy
  $
    S(t) =
    cases(
      pi t & "nếu " 0 <= t <= 1,
      pi(2-t^2) & "nếu " 1 <= t <= sqrt(2).
    )
  $

  Theo nguyên lý Cavalieri, thể tích của khối $E$ là
  $
    V(E)
    &= integral_0^(sqrt(2)) S(t) dif t \
    &= pi integral_0^1 t dif t
    + pi integral_1^(sqrt(2)) (2-t^2) dif t \
    &= pi [(frac(t^2,2)]_0^1)
    + pi [(2t-frac(t^3,3)]_1^sqrt(2)) \
    &= frac(pi,2)
    + pi(frac(4 sqrt(2),3)-frac(5,3)) \
  $
  
  
]
#pagebreak()
== 2011-2012
#cau[
  *Bài 1 (3 điểm).* Cho tích phân lặp:
  $
    integral_0^1 (
      integral_(x^2)^1 x e^(-y^2) dif y
    ) dif x
  $

  Giải thích vì sao có thể đổi thứ tự tích phân để tính tích phân này và hãy tính nó.
]

#cau[
  *Bài 2 (3 điểm).* Tính diện tích của miền phẳng được bao bởi đường cong
  $r = 4 + 3 cos(11 theta)$.

  #align(center)[
    #image("Tong Hop Hinh/hinh-cau-2.png", width: 45%)
  ]
]

#cau[
  *Bài 3 (3 điểm).* Gọi $E$ là khối được bao phía trên bởi mặt cầu
  $x^2 + y^2 + z^2 = 1$ và được bao phía dưới bởi mặt nón
  $z = sqrt(x^2 + y^2)$.

  Giải thích vì sao tích phân
  $
    integral.triple_E z dif V
  $
]

#cau[
  *Bài 4 (1 điểm).* Chọn một trong hai câu sau:

  a) Tính diện tích của miền phẳng được bao bởi các đường
  $y^2 = x$, $y^2 = 2x$, $y = 1/x$, $y = 2/x$.

  b) Tính thể tích của khối được miêu tả trong hình dưới đây:

  #align(center)[
    #image("Tong Hop Hinh/hinh-cau-4.png", width: 35%)
  ]
]
#loigiai[

  *Câu 1* Đặt $D={(x,y) in RR^2 : 0<=x<=1 ,x^2<=y<=1}$. Khi đó, ta có hình minh họa $D$ như sau,
  #figure(
    image("Tong Hop Hinh/hinh thi 2016.png",width: 36%),
  )
  Vì các cận đều là hàm liên tục, do đó xét $D$ đơn giản theo chiều ngang, ta được 
  $
  D={(x,y) in RR^2 : 0<=y<=1 ,0<=x<=sqrt(y)}.
  $
  Hơn nữa, hàm lấy tích phân là hàm liên tục, và các cận đều là hàm liên tục, do đó áp dụng công thức Fubini, ta có
  $
  integral_0^1(integral_(x^2)^1x e^(-y^2) dif y) dif x=integral_0^1 (integral_0^(sqrt(y) ) x e^(-y^2) dif x) dif y=integral_0^1 1/2 e^(-y^2)y dif y=-1/4 integral_0^1 e^(-y^2) dif (-y^2)
  $
  Do đó, đặt $u=-y^2 " với "y=0 => u=0 , y=1 =>u=-1$ . Vậy,
  $
  -1/4 integral_0 ^1 e^(-y^2) dif(-y^2)=1/4 integral_(-1)^0e^(u) dif u=1/4 (1-1/e)
  $

  *Câu 2* Từ hình vẽ, ta thấy $0<=r<=4+3cos(11 theta)$ và $0<=theta <=2pi$. Do đó, áp dụng công thức Fubini, ta có diện tích của miền phẳng trên là
  $
  integral_0^(2pi) integral_0^(4+3 cos(11theta) ) r dif r dif theta=1/2 integral_0^(2pi)(4+3 cos(11 theta))^2 dif theta&=1/2 integral_0^(2pi) (16 + 24 cos(11theta)+9 cos^2(11 theta))dif theta\
  &=1/2[ 16 theta + 24/11 sin(11 theta)+9/2(sin(22 theta)+theta)]_0^(2pi)\
  &=1/2(16 pi+9pi)=(25 pi)/2
  $

  *Câu 3*

   Ta có $E$ là khối được giới hạn bởi mặt cầu
  $x^2 + y^2 + z^2 = 1$ và mặt nón
  $z = sqrt(x^2 + y^2)$.

  Xét giao tuyến của hai mặt, ta có
  $
    cases(
      x^2 + y^2 + z^2 = 1,
      z^2 = x^2 + y^2
    )
    => 2(x^2 + y^2) = 1
    <=> x^2 + y^2 = 1/2.
  $

  Do đó, hình chiếu của $E$ xuống mặt phẳng $O x y$ là
  $
    D = {(x,y) in RR^2 : x^2 + y^2 <= 1/2}.
  $

  Với mỗi $(x,y) in D$, ta có
  $
    sqrt(x^2 + y^2) <= z <= sqrt(1 - x^2 - y^2).
  $

  Chuyển sang tọa độ trụ, đặt
  $
    cases(
      x = r cos theta,
      y = r sin theta,
      z = z.
    )
  $

  Khi đó, miền $E$ được xác định bởi
  $
    cases(
      0 <= theta <= 2 pi,
      0 <= r <= 1/sqrt(2),
      r <= z <= sqrt(1-r^2).
    )
  $

  Vì $d V = r dif z dif r dif theta$, theo công thức đổi biến trong tích phân bội ba, ta có
  $
    integral.triple_E z dif V
    &= integral_0^(2 pi) integral_0^(1/sqrt(2))
       integral_r^(sqrt(1-r^2)) z r dif z dif r dif theta \
    &= 2 pi integral_0^(1/sqrt(2))
       r [z^2/2]_r^(sqrt(1-r^2)) dif r \
    &= pi integral_0^(1/sqrt(2)) r (1 - 2r^2) dif r \
    &= pi [r^2/2 - r^4/2]_0^(1/sqrt(2)) \
    &= pi/8.
  $

  *Câu 4*

  *a)*

  
  *b)* Từ Hình,khối $Omega$ được giới hạn bởi các mặt
  $x = 0$, $x = 1$, $z = 0$, $z = e^(3 x)$,
  $y = -e^x$ và $y = e^(2 x)$.

  Hình chiếu của khối $Omega$ xuống mặt phẳng $O x y$ là miền

  $ D = { (x,y) in RR^2 : 0 <= x <= 1,
    -e^x <= y <= e^(2 x) }. $

  Vì $e^(3 x) > 0$ với mọi $x in [0,1]$, nên

  $ Omega = { (x,y,z) in RR^3 :
    (x,y) in D, 0 <= z <= e^(3 x) }. $

  Các hàm xác định cận đều liên tục trên $[0,1]$,
  nên có thể áp dụng công thức Fubini.

  Do đó, thể tích khối $Omega$ là

  $
    V(Omega)
    &= integral.triple_Omega 1 dif V \
    &= integral_0^1 integral_(-e^x)^(e^(2 x))
       integral_0^(e^(3 x)) 1 dif z dif y dif x \
    &= integral_0^1 integral_(-e^x)^(e^(2 x))
       e^(3 x) dif y dif x \
    &= integral_0^1 e^(3 x) (e^(2 x) + e^x) dif x \
    &= integral_0^1 (e^(5 x) + e^(4 x)) dif x \
    &= (e^5 - 1)/5 + (e^4 - 1)/4 \
    &= (4 e^5 + 5 e^4 - 9)/20.
  $
  * Cách Khác *
  Xét mặt phẳng $x = t$ với $0 <= t <= 1$,
  vuông góc với trục $O x$.

  Khi đó, thiết diện của khối $Omega$ bởi
  mặt phẳng $x = t$ là hình chữ nhật
  được giới hạn bởi

  $
    cases(
      -e^t <= y <= e^(2 t),
      0 <= z <= e^(3 t)
    ).
  $

  Do đó, diện tích thiết diện là

  $
    S(t) &= (e^(2 t) + e^t) e^(3 t) \
         &= e^(5 t) + e^(4 t).
  $

  Theo công thức tính thể tích qua diện tích
  thiết diện, ta có

  $
    V(Omega)
    &= integral_0^1 S(t) dif t \
    &= integral_0^1 (e^(5 t) + e^(4 t)) dif t \
    &= [e^(5 t)/5 + e^(4 t)/4]_0^1 \
    &= (4 e^5 + 5 e^4 - 9)/20.
  $
  
]
#pagebreak()
== 2016-2017
#cau[
  *Bài 1 (5 điểm).* Cho hàm số sau đây:
  $
    f(x,y) = cases(
      x^2 y: & 0 <= x <= 1 ", " 0 <= y <= 1 ", " y <= x^2,
      x y^2 :& 0 <= x <= 1 ", " 0 <= y <= 1 ", " y > x^2
    )
  $

  a) Vẽ miền xác định của hàm $f$.

  b) Giải thích vì sao hàm $f$ khả tích.

  c) Tính tích phân của hàm $f$. Giải thích đầy đủ cơ sở cho các tính toán này.
]

#cau[
  *Bài 2 (5 điểm).* Cho khối $E subset RR^3$ được bao bởi mặt
  $z = 4 - x^2 - y^2$, $y = x$ và $z = 0$ trong góc phần tám
  thứ nhất $(x,y,z >= 0)$.

  a) Vẽ khối $E$.

  b) Tính thể tích của khối $E$. Không cần giải thích cơ sở cho tính toán.
]
#loigiai[

  *Câu 1*

  Từ giả thiết, có miền xác định của $f$ là $D=[0,1]times[0,1]$. Hơn nữa, với $(x,y)in D$, nếu $y<=x^2$ thì $f(x,y)=x^2 y <= x^4 <=1,f(x,y)=x^4>=0$. Hơn nữa, nếu $y>x^2 => f(x,y)=x y^2 <y^3 <=1 , f(x,y)>=0$. Do đó, $f$ bị chặn trên $D$. Mặt khác, tập các điểm không liên tục của $f$ là
  $
  D_f={(x,y) in RR^2 : 0<=x<=1 , y=x^2}
  $
  Với mỗi $x in [0,1]$ thì đường cong $y=x^2$ liên tục trên $[0,1]$ nên đặc biệt khả tích, do đó đồ thị hàm số trên là $D_f$ có thể tích không.Vậy, $f$ khả tích.

  *c)* Với mỗi $(x,y) in D backslash D_f$, đặt $g=f$, khi đó vì $D_f$ có thể tích không, nên $integral.double_D f =integral.double_D g$. Khi đó, ta có thể chia $D$ thành $2$ miền $D_1$ và $D_2$, trong đó $
  D_1={(x,y) in RR^2 : 0<=x<=1 , 0<=y<=x^2}.
  $
  Và $
  D_2={(x,y) in RR^2 : 0<=x<=1, x^2<=y<=1}.
  $
  Khi đó, $D=D_1 union D_2$. Vậy
  $
  integral.double_D g =integral.double_D_1 g +integral.double_D_2 g
  $
]
#pagebreak()
== 2017-2018
#cau[
  *Bài 1 (4 điểm).* Cho hàm số $f: [0,1] times [0,1] arrow RR$ thỏa:
  $
    f(x,y) = cases(
      x : & y <= sqrt(1-x^2),
      0  :& y > sqrt(1-x^2)
    )
  $

  a) Vẽ miền xác định của hàm $f$.

  b) Giải thích vì sao hàm $f$ khả tích.

  c) Tính tích phân của hàm $f$. Giải thích đầy đủ cơ sở cho các tính toán này.
]

#cau[
  *Bài 2 (4 điểm).* Tính tích phân
  $
    integral.triple_E y dif V,
  $
  trong đó $E$ là khối dưới mặt phẳng $x + z = 1$
  nằm bên trên hình chữ nhật $[0,1] times [0,1]$.
]

#cau[
  *Bài 3 (2 điểm).* Cho khối $E$ nằm trong quả cầu
  $x^2 + y^2 + z^2 = 4$ và phía trên mặt nón
  $z = sqrt(x^2 + y^2)$.

  a) Vẽ khối $E$.

  b) Tính thể tích khối $E$.

  c) #text(fill: red)[(Thưởng 1 điểm)]
  Dựa trên cơ sở gì để cho rằng thể tích khối $E$
  bằng 4 lần thể tích của phần của khối $E$
  thuộc phần không âm $x,y,z >= 0$?
]
#loigiai[

  *Câu 1*

  Từ giả thiết, ta thấy miền xác định $D$ của $f$ là hình hộp $[0,1]times [0,1]$. Hơn nữa, tập các điểm không liên tục của $f$ là 
  $
  D_f ={(x,y) in RR^2 : y=sqrt(1-x^2)}.
  $
  Với mỗi $x in [0,1]$, thì đường cong $y=sqrt(1-x^2)$ xác định trên $[0,1]$ hơn nữa hàm $sqrt(1-x^2)$ là hàm đa thức, do đó liên tục, và đặc biệt khả tích, suy ra đồ thị hàm số của đường cong trên là $D_f$ có thể tích không.

  Hơn nữa, $f$ bị chặn trên $D$, vì ta có thể chọn $M=10>0$ sao cho $abs(f)<=10$. Vậy, $f$ khả tích trên $D$.

  *c)* Với mỗi $(x,y) in D backslash D_f$, đặt $g=f$, khi đó vì $V(D_f)=0$, nên $
  integral.double_D g =integral.double_D f
  $
  Mặt khác, với mỗi $(x,y) in D$, ta chia $D$ thành $2$ miền thỏa $D_1= {(x,y) in D : y<=sqrt(1-x^2)}$ và $D_2={(x,y) in D_2 : y> sqrt(1-x^2)}$. Khi đó,
  $
  integral.double_D f &=integral.double_D_1 f + integral.double_D_2 f\
  &=integral_0^1 integral_0^(sqrt(1-x^2)) x dif y dif x + integral_0^1 integral_(sqrt(1-x^2))^1 0 dif y dif x\
  &=integral_0^1 x (sqrt(1-x^2)) dif x=-1/2 integral_0^1 -2 x sqrt(1-x^2) dif x " đặt" u=sqrt(1-x^2) => u^2=1-x^2 =>2 u dif u=-2 x dif x\
  &=-1/2 integral_1^0 2 u^2 dif u=integral_0^1 u^2 dif u=1/3
  $
  Cơ sở để áp dụng công thức Fubini trên, là hàm lấy tích phân và các cận đều là các hàm liên tục.

  *Câu 2* Xét $E$ là khối đơn giản theo chiều $z$, khi đó với mỗi $(x,y) in D =[0,1]times [0,1]$ thì $0<=z<=1-x$, do đó
  $
  integral.triple_E y dif V=integral_0^1 integral_0^1 integral_0^(1-x) y dif z dif y dif x=integral_0^1 integral_0^1y(1-x) dif y dif x=integral_0^1 [y^2/2(1-x)y]_(y=0)^(y=1)=integral_0^1 1/2(1-x) dif x=1/2[x-x^2/2]_0^1=1/4
  $
  *Câu 3*
  *a)* Ta có minh họa khối $E$ như sau
  #figure(
    image("Tong Hop Hinh/hinh 2017-2018 cau4.png",width: 67%),
  )
  *b)* Ta có giao của $2$ mặt $x^2+y^2+z^2=4$ và $z=sqrt(x^2+y^2)$ là $x^2+y^2=2$, do đó với mỗi điểm $(x,y) in RR^2 : x^2+y^2<=2$, thì $sqrt(x^2+y^2)<=sqrt(4-x^2-y^2)$.
  Do đó, thể tích cần tính là
  $
  V=integral.double _D (sqrt(4-x^2-y^2)-sqrt(x^2+y^2)) dif A
  $
  
  
]
#pagebreak()
== 2018-2019
#cau[
  *Bài 1 (3 điểm).* Xác định hàm nào sau đây khả tích Riemann?
  Giải thích và hãy tính tích phân nếu hàm khả tích.

  a) Hàm Dirichlet $f: [0,1] arrow RR$ được định nghĩa bởi:
  $
    f(x) = cases(
      1 : & x in [0,1] inter QQ,
      0 : & x in [0,1] backslash QQ
    )
  $

  b) Hàm $g: [0,1] arrow RR$ được định nghĩa bởi:
  $
    g(x) = cases(
      1 : & x = 2/3,
      0 : & x in [0,1] backslash {2/3}
    )
  $

  c) Hàm $h: [0,1] times [0,1] arrow RR$ được định nghĩa bởi:
  $
    h(x,y) = cases(
      y + ln x : & 0 < x <= 1 ", " 0 <= y <= 1,
      0 : & x = 0 ", " 0 <= y <= 1
    )
  $
]

#cau[
  *Bài 2 (4 điểm).*

  a) Tính tích phân
  $
    integral_0^1 integral_x^(sqrt(x))
    (x+y) dif y dif x.
  $

  b) Cho miền phẳng có dạng hình bình hành:
  $
    R = { (x,y) |
      3x-y=1, 3x-y=2,
      x+2y=-2, x+2y=0
    }
  $

  i) Tìm một phép đổi biến để biến hình bình hành $R$
  thành hình chữ nhật $D = [1,2] times [-2,0]$.

  ii) Tính tích phân
  $
    integral.double_R (x+2y)/(3x-y) dif A.
  $
]

#cau[
  *Bài 3 (3 điểm).* Cho $E$ là khối tứ diện gồm các đỉnh
  $O(0,0,0)$, $A(1,0,0)$, $B(1,2,0)$ và $C(0,0,3)$.

  a) Vẽ khối tứ diện $E$.

  b) Tính thể tích khối $E$.
]

#pagebreak()
== 2019-2020
#cau[
  *Bài 1 (2 điểm):* Xác định hàm nào sau đây khả tích Riemann?
  Giải thích và hãy tính tích phân nếu hàm khả tích.

  a) Hàm $f: [0,1] arrow RR$ được định nghĩa bởi:
  $
    f(x) = cases(
      1/(1-x)^2 : & x in [0,1),
      0 : & x = 1
    )
  $

  b) Hàm $g: [0,1] times [0,1] arrow RR$ được định nghĩa bởi:
  $
    g(x,y) = cases(
      1 : & x in [0,1] ", " y in [0,1] backslash {1/2},
      -1 : & x in [0,1] ", " y = 1/2
    )
  $
]

#cau[
  *Bài 2 (1 điểm):* Hãy cho ví dụ một hàm không khả tích Riemann
  trên hình hộp $[0,1]^2$ và giải thích vì sao không khả tích.
]

#cau[
  *Bài 3 (7 điểm):*

  a) *(1,5 điểm)* Tính tích phân
  $
    integral_0^1 integral_(x^3)^(sqrt(x))
    x y dif y dif x.
  $

  b) Cho miền phẳng có dạng hình bình hành:
  $
    R = { (x,y) :
      x - 2y = 2,
      x - 2y = 3,
      2x + y = -3,
      2x + y = 1
    }
  $

  i) *(1 điểm)* Tìm một phép đổi biến để biến hình bình hành
  $R$ thành hình chữ nhật $D = [2,3] times [-3,1]$.

  ii) *(1,5 điểm)* Tính tích phân
  $
    integral.double_R (2x+y)/(x-2y) dif A.
  $

  c) Cho $E$ là khối tứ diện gồm các đỉnh
  $O(0,0,0)$, $A(2,1,0)$, $B(0,1,0)$ và $C(0,0,2)$.

  i) *(1 điểm)* Vẽ khối tứ diện $E$.

  ii) *(1 điểm)* Viết phương trình mặt phẳng chứa 3 điểm $A,B,C$.

  iii) *(1 điểm)* Tính thể tích khối $E$.
]
#v(1em)
#line(length: 100%, stroke: 0.8pt)
#v(0.8em)

#align(center)[
  #text(size: 10pt, weight: "bold")[
    _HƯỚNG DẪN GIẢI_
  ]
]
#loigiai[

  *Câu 1*

  *a)* Ta thấy, $f$ không bị chặn vì $
  lim_(x->1) f(x)=lim_(x->1)1/(1-x)^2=infinity
  $
  Do đó, $f$ không khả tích trên $D$.

  *b)* Với $D={(x,y) in RR^2 : 0<=x<=1,0<=y<=1}$, ta có tập điểm gián đoạn của $f$ là
  $
  D_f={(x,y) in RR^2 : 0<=x<=1,y=1/2}={(x,1/2)in RR^2: 0<=x<=1}.
  $.
  Khi đó, $V(D_f)=0$, do $D_f$ là đồ thị của hàm liên tục trên hình hộp đóng và bị chặn nên hàm khả tích.

  Hơn nữa, tại các điểm ngoài $D backslash D_f$, ta có $f$ là hàm sơ cấp nên xác định và liên tục. Mặt khác, có $abs(f(x))<=1,forall x in D$. Do đó, $f$ bị chặn. Vậy $f$ khả tích. Khi đó, vì $V(D_f)=0$, nên ta đặt $g=f "trên" D backslash D_f$. Khi đó, 
  $
  integral_D f=integral_D g=integral_0^1 integral_0 ^1 1 dif y dif x=1
  $

  *Câu 2* 
  Xét hàm số : $f : [0,1]times[0,1] -> RR$. Với $
  f(x,y)=cases(x/(1-y)^2 &:quad x in [0,1] ", " y in [0,1] backslash {1},0 &:quad x in [0,1] "," y=1).
  $
  Khi đó, ta có $f$ không bị chặn vì, với $x_0=1 in [0,1]$, ta có $
  lim_(x,y->(x_0,1)) f(x,y)=infinity
  $
  Do đó, $f$ không bị chặn. Vậy $f$ không khả tích Riemann.

  *Câu 3*

  *a)*
  Có tích phân
  $
  integral_0^1 integral_(x^3)^sqrt(x) x y dif y dif x&=integral_0^1 [(x y^2/2)]_(x^3)^sqrt(x) dif x=integral_0^1(x^2/2-x^7/2)dif x=5/48  $
   *b) Cho miền phẳng $R$ là hình bình hành.*

  *i) Tìm phép đổi biến.*

  Ta có miền $R$ được giới hạn bởi các đường thẳng
  $
    x-2y=2, quad x-2y=3,
  $
  $
    2x+y=-3, quad 2x+y=1.
  $

  Đặt phép đổi biến
  $
    cases(
      u = x-2y,
      v = 2x+y.
    )
  $

  Khi đó, miền $R$ được biến thành miền
  $
    D = {(u,v) in RR^2 :
    2 <= u <= 3, -3 <= v <= 1}.
  $

  Suy ra
  $
    D = [2,3] times [-3,1].
  $

  Từ phép đổi biến, ta có
  $
    cases(
      x = frac(u+2v,5),
      y = frac(v-2u,5).
    )
  $

  Định thức Jacobi của phép đổi biến là
  $
    J
    &= frac(partial(u,v),partial(x,y)) \
    &= mat(1, -2; 2, 1) \
    &= 1 + 4 = 5.
  $

  Do đó
  $
    dif x dif y = frac(1,5) dif u dif v.
  $

  *ii) Tính tích phân.*

  Xét tích phân
  $
    I = integral.double_R
    frac(2x+y,x-2y) dif A.
  $

  Áp dụng phép đổi biến ở câu i), ta được
  $
    I
    &= frac(1,5)
    integral_2^3 integral_(-3)^1
    frac(v,u) dif v dif u \
    &= frac(1,5)
    integral_2^3 frac(1,u)
    [frac(v^2,2)]_(-3)^1 dif u \
    &= frac(1,5)
    integral_2^3 frac(1,u)
    (frac(1,2)-frac(9,2)) dif u \
    &= -frac(4,5)
    integral_2^3 frac(1,u) dif u \
    &= -frac(4,5) [ln u]_2^3 \
    &=-4/5 [ln(3)-ln(2))].
  $

  *c)*

  *i)* Có hình minh họa khối $E$ như sau
  #figure(
    image("Tong Hop Hinh/hinh 2019--.png",width: 45%),
  )
   Ba điểm $O,A,B$ thuộc mặt phẳng $O x y$, do đó tam giác $O A B$ là mặt đáy của khối tứ diện. Điểm $C$ nằm trên trục $O z$.

  *ii) Viết phương trình mặt phẳng chứa ba điểm $A,B,C$.*

  Ta có
  $
    A B = (-2,0,0), quad
    A C = (-2,-1,2).
  $

  Suy ra một vectơ pháp tuyến của mặt phẳng $(A B C)$ là
  $
    vec(n) = (0,2,1).
  $

  Phương trình mặt phẳng $(A B C)$ đi qua điểm $A(2,1,0)$ là
  $
    0(x-2)+2(y-1)+z=0.
  $

  *iii) Tính thể tích khối $E$.*

  *Cách 1. Sử dụng công thức thể tích hình chóp.*

  Vì tam giác $O A B$ nằm trên mặt phẳng $O x y$ nên chiều cao của khối tứ diện là $h=2$.

  Mặt khác, tam giác $O A B$ có đáy $O B=1$ và chiều cao tương ứng bằng $2$, do đó
  $
    S_(O A B) = frac(1,2) times 1 times 2 = 1.
  $

  Suy ra thể tích khối $E$ là
  $
    V(E)
    &= frac(1,3) S_(O A B) h \
    &= frac(1,3) times 1 times 2 \
    &= frac(2,3).
  $

  *Cách 2. Sử dụng tích phân bội ba.*

  Chiếu khối $E$ xuống mặt phẳng $O x y$, ta được miền tam giác $D$ có các đỉnh $O(0,0)$, $A(2,1)$ và $B(0,1)$.

  Đường thẳng $O A$ có phương trình
  $
    x=2y.
  $

  Do đó
  $
    D = {(x,y) in RR^2 :
    0 <= y <= 1, 0 <= x <= 2y}.
  $

  Mặt phẳng $(A B C)$ có phương trình
  $
    z=2-2y.
  $

  Suy ra khối $E$ được xác định bởi
  $
    E = {(x,y,z) in RR^3 :
    0 <= y <= 1,
    0 <= x <= 2y,
    0 <= z <= 2-2y}.
  $

  Khi đó
  $
    V(E)
    &= integral_0^1 integral_0^(2y)
    integral_0^(2-2y) 1 dif z dif x dif y \
    &= integral_0^1 integral_0^(2y)
    (2-2y) dif x dif y \
    &= integral_0^1 (2-2y) 2y dif y \
    &= 4 integral_0^1 (y-y^2) dif y \
    &= 4 [frac(y^2,2)-frac(y^3,3)]_0^1 \
    &= 4(frac(1,2)-frac(1,3)) \
    &= frac(2,3).
  $

  
]
#pagebreak()
== 2022-2023
#cau[
  *Bài 1 (2 điểm):* Cho $D subset RR^2$ với
  $
    D = { (x,y) in RR^2 : 0 <= x <= 1, 0 <= y <= x }
  $
  và hàm số $f: D arrow RR$ với:
  $
    f(x,y) = ln(x^4 + y^3 + 1)
  $

  Tích phân $integral.double_D f$ có tồn tại hay không?
  Nếu có, hãy ước lượng giá trị của nó, tức xác định
  giá trị của tích phân nằm trong khoảng số thực nào
  (khoảng càng nhỏ càng tốt).
]

#cau[
  *Bài 2 (2 điểm):* Hai cái vại có dạng đồ thị của hàm
  $z = x^2 + y^2$ và $z = (x - 3)^2 + y^2$,
  với $0 <= z <= 1$ (xem hình bên dưới).

  Hãy giải thích vì sao hai cái vại này lại có thể
  đựng được cùng một lượng nước (tức là bao hai khối
  có thể tích bằng nhau), và hãy tính lượng nước đó.

  #align(center)[
    #image("Tong Hop Hinh/hinh-bai-2-vai-nuoc.png", width: 55%)
  ]
]

#cau[
  *Bài 3 (3 điểm):* Cho $E subset RR^3$ là khối được
  bao bởi các mặt $z = 0$, $z = 1$, $y = 0$,
  $y = 1 - x^2$.

  Tính tích phân
  $
    integral.triple_E y dif V.
  $
]

#cau[
  *Bài 4 (3 điểm):* Khu trung tâm thành phố được miêu tả
  như một hình tam giác với các đỉnh $(0,0)$, $(2,1)$,
  $(0,3)$.

  Giá đất trong khu vực này được mô hình hóa bằng hàm
  $p(x,y) = x + y$ (trăm triệu đồng/$"m"^2$).

  Hãy tính giá đất trung bình ở khu vực này.

  Giá trị trung bình của hàm $f$ trên miền $D$ được
  định nghĩa là tích phân của $f$ trên $D$ chia cho
  thể tích của $D$, tức là
  $
    1/(|D|) integral_D f.
  $
]
#v(1em)
#line(length: 100%, stroke: 0.8pt)
#v(0.8em)

#align(center)[
  #text(size: 10pt, weight: "bold")[
    _HƯỚNG DẪN GIẢI_
  ]
]
#loigiai[

  *Câu 1* Ta thấy, $D$ là miền hình tam giác nên $D$ đóng và bị chặn, hơn nữa $partial D$ là đoạn thẳng nên $V(partial D)=0 => D$ có thể tích. Mặt khác, $f$ xác định và liên tục trên $D$, từ $D$ là tập đóng và bị chặn, ta suy ra $f$ bị chặn hay $f$ khả tích trên $D$. Do đó, $integral.double_D f$ tồn tại, mặt khác
  $
  0<=x^4<=1 => 0<=x^4 +y^3<=2 => 1<=x^4+y^3+1<=3 => ln(1)<=ln(x^4+y^3+1)<=ln(3)
  $
  Do đó,
  $
  integral.double_D 0<= integral.double_D f<=integral.double_D ln(3)=abs(D)ln(3)=ln(3)/2
  $

  *Câu 2*

  Đặt $Omega_1$ là khối tạo bởi đồ thị của hàm $z=x^2+y^2$ và $Omega_2$ là khối tạo bởi đồ thị của hàm $z=(x-3)^2+y^2$, với $0<=z<=1$. Khi đó, ta xét mặt phẳng $z=t, 0<=t<=1$, cắt $Omega_1 "và" Omega_2$ bởi $z=t$, ta thu được các thiết diện là hình tròn có bán kính $1$. Do đó, $forall t in [0,1]$ thì $V(S_1)=V(S_2)$, theo nguyên lý Calleveri thì $V(Omega_1)=V(Omega_2)$.

  Mặt khác, với $Omega_1={(x,y,z) in RR^3 : x,y,z >=0 , x^2+y^2<=z<=1}$. Suy ra,
  $
  V(Omega)=integral.triple_Omega_1 1 dif V=integral.double_(x^2+y^2<=1) (1-x^2-y^2) dif A =pi/2
  $

  *Câu 3*

  Từ giả thiết, ta có
  $
  E={(x,y,z) in RR^3 :x,y,z>=0,0<=z<=1,0<=y<=1,-sqrt(1-y)<=x<=sqrt(1-y)}
  $
  Do đó,
  $
  integral.triple_E y dif V=integral_0^1 integral_0 ^1  integral_(-sqrt(1-y)) ^(sqrt(1-y)) y dif x dif y dif z=8/15
  $

  *Câu 4* Gọi $D$ là khối tam giác với các đỉnh như giả thiết, khi đó ta có miền $D$ đơn giản theo chiều ngang, ta được :

  $
  D={(x,y) in RR^2 :0<=x<=2 , 1/2x <=y <=3-x}
  $
  Do đó, áp dụng công thức Fubini, ta được
  $
  integral.double_D f dif A=integral_0^2 (integral_(x/2)^ (3-x) x+y) dif y dif x
  = integral_0 ^2 (9/2-9/8 x^2) dif x=6
  $
  Hơn nữa, vì $D$ là hình tam giác, nên $abs(D)=1/2 times 3 times 2=3$. Do đó, 
  $
  integral.double_D p(x,y) 1/ abs(D)=2 => "Giá đất trung bình là "20.000.000 "VNĐ".
  $
  
]
#pagebreak()
== 2023-2024
#cau[
  *Bài 1 (4 điểm):* Cho $D subset RR^2$ là miền nằm phía trên trục $x$,
  bị chặn bởi các đồ thị của hàm $y = sqrt(x)$ và $x = 4 - y^2$.
  Xét hàm $f: D arrow RR$ cho bởi:
  $
    f(x,y) = cases(
      x y : & x != 2,
      1 : & x = 2
    )
  $

  a) Chứng tỏ $f$ khả tích trên $D$.

  b) Tính tích phân của $f$ trên $D$.
  Giải thích cơ sở của các phép tính.
]

#cau[
  *Bài 2 (3 điểm):* Tính thể tích của khối dưới đây

  #align(center)[
    #image("Tong Hop Hinh/hinh-bai-2-khoi-da-dien.png", width: 50%)
  ]

  bằng cách tính tích phân theo thứ tự:

  a) $dif x dif y dif z$.

  b) $dif y dif z dif x$.

  c) $dif z dif x dif y$.
]

#cau[
  *Bài 3 (3 điểm):* Một tấm mỏng $D$ có hình dạng là miền
  trong $RR^2$ được bao bởi hai đường ellipse
  $9x^2 + 4y^2 = 1$ và $9x^2 + 4y^2 = 4$.
  Đổi biến:
  $
    x = 1/3 r cos theta, quad
    y = 1/2 r sin theta
  $

  a) Tính định thức của ma trận Jacobi của phép đổi biến.

  b) Tìm miền xác định của biến $r$ và biến $theta$.

  c) Khối lượng của tấm mỏng được cho bằng tích phân của
  mật độ khối lượng. Tấm mỏng $D$ có mật độ khối lượng
  được cho bởi hàm $rho(x,y) = 18x^2 + 8y^2$.
  Tính khối lượng của $D$.
]

#cau[
  *Bài 4 (Thưởng 1 điểm):* Cho hình hộp $I$ và hàm bị chặn
  $f: I arrow RR$. Hỏi nếu $abs(f)$ khả tích (Riemann)
  thì $f$ có khả tích không?
  Hãy chứng minh hoặc đưa ra phản ví dụ.
]

#v(1em)
#line(length: 100%, stroke: 0.8pt)
#v(0.8em)

#align(center)[
  #text(size: 10pt, weight: "bold")[
    _HƯỚNG DẪN GIẢI_
  ]
]
#loigiai[

  *Câu 1* Có phương trình hoành độ giao điểm của $2$ đường cong trên là $
  x=4-x<=>x=2 => y=sqrt(2) => A=(2,sqrt(2)) "là giao điểm của 2 đường cong đã cho"
  $
  Do đó, nếu đơn giản theo phương ngang, thì
  $
  D={(x,y) in RR^2 : 0<=y<=sqrt(2),y^2<=x<=4-y^2}
  $

  *a)* Vì $D$ bị chặn và biên của $D$ là các đường cong liên tục nên $D$ có thể tích, mặt khác, $f$ bị chặn trên $D$ và tập điểm gián đoạn của $f$ là 
  $
  D_f={(x,y) in D : x=1} "là đoạn thẳng" => D_f "có thể tích không" 
  $
  Do đó, $f$ khả tích trên $D$.

  *b)* Đặt $g=f "trên D"backslash D_f$. Vì $V(D_f)=0 => integral_D f=integral_D g$. Hơn nữa, vì $f$ liên tục trên $D backslash D_f$ nên $g$ liên tục, do đó $g$ đặc biệt khả tích và áp dụng công thức Fubini, ta có
  $
  integral.double _D f=integral.double _D g=integral_(0)^sqrt(2) (integral_(y^2) ^(4-y^2) x y dif x) dif y= integral_0^sqrt(2)(y x^2/2 | _(y^2) ^(4-y^2))dif y=integral_0 ^sqrt(2) (-4y^3+8y) dif y=4
  $

  *Câu 2*
  
Khối tứ diện $D$ có bốn đỉnh:
$
O(0,0,0), quad A(3,0,0), quad B(0,1,0), quad C(0,0,2).
$

Mặt phẳng đi qua ba điểm $A,B,C$ có phương trình:
$
x/3 + y + z/2 = 1.
$

Do đó, miền $D$ được xác định bởi:
$
D = { (x,y,z) in RR^3 : x,y,z >= 0, x/3 + y + z/2 <= 1 }.
$

Thể tích của khối $D$ là:
$
V(D) = integral.triple_D 1 dif x dif y dif z.
$

*a) Tính theo thứ tự $dif x dif y dif z$.*

Ta có:
$
cases(
  0 <= z <= 2,
  0 <= y <= 1 - z/2,
  0 <= x <= 3(1-y-z/2).
)
$

Suy ra:
$
V(D)
&= integral_0^2 integral_0^(1-z/2)
integral_0^(3(1-y-z/2)) dif x dif y dif z \
&= 3 integral_0^2 integral_0^(1-z/2)
(1-y-z/2) dif y dif z \
&= 3/2 integral_0^2 (1-z/2)^2 dif z \
&= 3/2 [-2/3 (1-z/2)^3]_0^2 \
&= 1.
$

*b) Tính theo thứ tự $dif y dif z dif x$.*

Ta có:
$
cases(
  0 <= x <= 3,
  0 <= z <= 2(1-x/3),
  0 <= y <= 1-x/3-z/2.
)
$

Suy ra:
$
V(D)
&= integral_0^3 integral_0^(2(1-x/3))
integral_0^(1-x/3-z/2) dif y dif z dif x \
&= integral_0^3 integral_0^(2(1-x/3))
(1-x/3-z/2) dif z dif x \
&= integral_0^3 (1-x/3)^2 dif x \
&= [-(1-x/3)^3]_0^3 \
&= 1.
$

*c) Tính theo thứ tự $dif z dif x dif y$.*

Ta có:
$
cases(
  0 <= y <= 1,
  0 <= x <= 3(1-y),
  0 <= z <= 2(1-y-x/3).
)
$

Suy ra:
$
V(D)
&= integral_0^1 integral_0^(3(1-y))
integral_0^(2(1-y-x/3)) dif z dif x dif y \
&= 2 integral_0^1 integral_0^(3(1-y))
(1-y-x/3) dif x dif y \
&= 3 integral_0^1 (1-y)^2 dif y \
&= 3 [-(1-y)^3/3]_0^1 \
&= 1.
$
  
]
#pagebreak()

== 2024-2025
#cau[
  *Bài 1 (2,5 điểm).* Cho tích phân
  $
    a = integral_0^1 (
      integral_(root(3, y))^1 root(4, x^5 + 1) dif x
    ) dif y.
  $

  a) Tìm miền $D subset RR^2$ sao cho
  $
    a = integral.double_D root(4, x^5 + 1) dif x dif y.
  $

  b) Tính $a$.
]

#cau[
  *Bài 2 (2,5 điểm).* Gọi $E$ là khối bao bởi hai mặt
  $z = x^2 + y^2$ và $z = 2 - x^2 - y^2$ trong $RR^3$.

  a) Vẽ khối $E$.

  b) Tính thể tích của khối $E$.
]

#cau[
  *Bài 3 (5 điểm).* Cho $D$ là một tập con đóng, bị chặn,
  có thể tích của $RR^n$ và cho hàm $f: D arrow RR$
  liên tục. Giá trị trung bình của hàm $f$ được định nghĩa
  là số thực
  $
    1/ (|D|) integral_D f.
  $

  a) Giải thích vì sao tồn tại giá trị trung bình của $f$.

  b) Cho $D$ là khối tứ diện với các đỉnh
  $(0,0,0)$, $(1,0,0)$, $(0,2,0)$, $(0,0,2)$.
  Cho hàm mật độ khối lượng của khối là
  $f: D arrow RR$, $f(x,y,z) = y$.
  Hãy tính mật độ khối lượng trung bình của khối.

  c) Gọi $f_min$ là giá trị nhỏ nhất và $f_max$ là
  giá trị lớn nhất của $f$ trên $D$.
  Chứng tỏ giá trị trung bình của hàm phải nằm giữa
  giá trị nhỏ nhất và giá trị lớn nhất của hàm, tức là
  $
    f_min <= 1/(|D|) integral_D f <= f_max.
  $

  d) *(Thưởng, 1 điểm)* Chứng tỏ rằng nếu $D$ là
  một hình hộp, thì giá trị trung bình của hàm đạt được
  tại một điểm nào đó, tức là có $x_0 in D$ sao cho
  $
    f(x_0) = 1/(|D|) integral_D f.
  $
]

#v(1em)
#line(length: 100%, stroke: 0.8pt)
#v(0.8em)

#align(center)[
  #text(size: 10pt, weight: "bold")[
    _HƯỚNG DẪN GIẢI_
  ]
]
#loigiai[

  *Câu 1* Xét tích phân
  $
  a=integral_0^1 (integral_root(3,y)^1 root(4,x^5+1) dif x ) dif y
  $

  *a)* Dễ thấy $D={(x,y) in RR^2 : 0<=y<=1,root(3,y)<=x<=1}$. Do đó, nếu đơn giản theo chiều dọc, ta được. $D={(x,y) in RR^2 : 0<=x<=1,0<=y<=x^3}$.

  *b)* Do đó, theo câu a), thì $
  a=integral_0^1 (integral_0^x^3 root(4,x^5+1) dif y) dif x=integral_0^1( root(4,x^5+1) x^3 dif x)=
  $

  *Câu 2* 
  
  *a)* Ta có hình minh họa sau 
  #figure(
    image("Tong Hop Hinh/hinh -gk-2024.png",width: 45%),
  )
  *b)* Ta có giao của $2$ mặt là $x^2+y^2=1$. Do đó, trên mặt phẳng $0 x y$, xét $D={(x,y) in RR^2 : x^2+y^2<=1}$. Khi đó, thể tích của khối E là
  $
  V(E)=integral.double_D 2-2x^2-2y^2 d A
  $

  *Câu 3*
  
  *a)* Có $D$ là tập con đóng và bị chặn, $D$ có thể tích. Hơn nữa, có $f$ liên tục trên $D$, do đó $f$ bị chặn trên $D$. Suy ra, $f$ khả tích và $integral_D f $ tồn tại, do đó giá trị trung bình $f$ tồn tại.

  *b)* Từ giả thiết ta có $V(D)=1/2 times 1 times 2 times 2times 1/3=2/3$. Hơn nữa, mặt phẳng đi qua $3$ điểm $A=(1,0,0),B=(0,2,0),C=(0,0,2)$ có dạng $x/1+y/2+z/2=1 =>z=2-2x-y$. Hơn nữa, chiếu khối $D$ xuống Oxy,ta được $
  D={(x,y) in RR^2 : 0<=x<=1 , 0<=y<=2-2x}.
  $
  Do đó, $
  Omega={(x,y,z) in RR^3 : 0<=x<=1,0<=y<=x,0<=z<=2-2x-y}
  $
  Suy ra,$
  integral.triple _Omega f(x,y,z)dif V=integral_(0)^1 integral_0 ^(2-2x) integral_0 ^(2-2x-y) y dif z dif y dif x=integral_0^1 (integral_0 ^(2-2x) y(2-2x-y) dif y )dif x=integral_0 ^1 4/3(1-x)^3 dif x=1/3
  $
  Do đó, mật độ trung bình của khối là $
  1/3 / (2/3)=1/2
  $
  *c)* Có,
  $
  f_min <= f<= f_max => f_min integral_D 1<=integral_D f<= f_max integral_D 1=> f_min <=1/(abs(D)) integral_D f<= f_max
  $
  
]

#pagebreak()
== 2025-2026
#cau[
  *Câu 1 (2 điểm).* Cho $f$ khả tích trên $D$.
  Giả sử $|f|$ khả tích trên $D$.
  Chứng tỏ
  $
    abs(integral_D f) <= integral_D abs(f).
  $
]

#cau[
  *Câu 2 (3 điểm).* Hãy tính tích phân lặp sau đây
  bằng cách đổi thứ tự tính, giải thích cơ sở của lý luận.
  $
    integral_0^1 integral_(sqrt(x))^1
    sqrt(y^3 + 1) dif y dif x.
  $
]

#cau[
  *Câu 3 (3 điểm).* Gọi $D$ là miền bao bởi các đồ thị
  $y = x^2$ và $x = y^2$.

  a) Giải thích vì sao $D$ có diện tích.

  b) Tính thể tích của khối bên dưới mặt phẳng
  $3x + 2y - z = 0$ và bên trên $D$.
]

#cau[
  *Câu 4 (2 điểm).* Với một điểm $P = (x,y) in RR^2$,
  gọi $r$ là khoảng cách từ $O = (0,0)$ tới $P$,
  và $theta$ là góc từ vectơ $(1,0)$ tới vectơ $O P$.

  Gọi $D$ là miền được bao bởi đường cong cho bởi
  phương trình
  $
    r = 5/4 + sin(5 theta),
  $
  là tập hợp tất cả các điểm có khoảng cách tới gốc tọa độ
  nhỏ hơn hay bằng $5/4 + sin(5 theta)$, tức $D$ là miền
  khi chuyển sang tọa độ cực trở thành miền
  $
    { (r,theta) in RR^2 |
      0 <= r <= 5/4 + sin(5 theta),
      0 <= theta <= 2 pi
    }.
  $

  Xem Hình 6. Tính diện tích của $D$.

  #figure(
    image("Tong Hop Hinh/hinh-mien-D-desmos.png", width: 35%),
  )
  #align(center)[Hình 6 : Miền D]
]
#v(1em)
#line(length: 100%, stroke: 0.8pt)
#v(0.8em)

#align(center)[
  #text(size: 10pt, weight: "bold")[
    _HƯỚNG DẪN GIẢI_
  ]
]

#loigiai[

  *Câu 1 : * Với $f$ khả tích trên $D$, giả sử $|f|$ khả tích trên $D$. Khi đó, luôn có
  $
  -abs(f) <=f<=abs(f)
  $
  Do $abs(f)$ khả tích trên $D$, nên $-abs(f)$ cũng khả tích trên $D$, suy ra lấy tích phân trên $D$, ta được
  $
  -integral_D abs(f)<= integral_D f <= integral_D abs(f) <=> abs(integral_D f)<=integral_D abs(f)
  $
  Vậy, ta có điều phải chứng minh.

  *Câu 2 : * Xét tích phân
  $
  integral_0^1(integral_(sqrt(x))^1 sqrt(y^3+1) dif y)dif x=integral.double_D (sqrt(y^3+1))dif A
  $
  Suy ra, có $D={(x,y)in RR^2 : 0<=x<=1, sqrt(x)<=y<=1}$, xét đơn giản theo chiều ngang, ta có
  $
  D={(x,y)in RR^2: 0<=y<=1 , 0<=x<=y^2}.
  $
  Hơn nữa, do hàm lấy tích phân và các cận là các hàm liên tục, đặc biệt với $f=sqrt(y^3+1)$ liên tục nên đặc biệt khả tích, do đó áp dụng công thức Fubini, ta có
  $
  I=integral_(0)^1(integral_0 ^(y^2) sqrt(y^3+1) dif x) dif y=integral_0 ^1 sqrt(y^3+1) y^2 dif y =0.406
  $

  *Câu 3 : *
  
  *a)* Có giao điểm giữa $2$ đường cong $x=y^2$ và $y=x^2$ là $A=(0,0),B=(1,1)$. Do đó, ta luôn có $D$ bị chặn bởi $I=[0,1]times[0,1]$. Hơn nữa, dễ thấy
  $
  partial D=D_1 union D_2={(x,y) in RR^2:0<=x<=1,x=y^2} union {(x,y) in RR^2: 0<=x<=1,y=x^2}
  $
  Dễ thấy, các hàm số $x=y^2, y=x^2$ đều là các hàm liên tục trên $[0,1]$, nên đồ thị hàm số trên ứng với $D_1$ và $D_2$ đều có diện tích không. Nên suy ra, $V(partial D)=0$. Do đó, $D$ có diện tích.

  *b)*Theo câu a), xét đơn giản theo chiều dọc thì $
  D={(x,y) in RR^2 : 0<=x<=1,x^2<=y<=sqrt(x)}.
  $ .Bên trên $D => z>=0$, mặt khác $z<=3x+2y$. Do đó, thể tích của khối bên dưới mặt phẳng cần tính là
  $
  integral.triple_(Omega) 1 dif V=integral.double_D (3x+2y)=integral_(0)^1 (integral_(x^2)^sqrt(x)(3x+2y) dif y) dif x=integral_0^1 (3x(sqrt(x)-x^3)+x-x^4) dif x=5/4
  $

  *Câu 4 : * Diện tích của $D$ là
  $
  integral_0 ^(2pi) (integral_0 ^(5/4+sin(5theta)) r dif r)dif theta=integral_0 ^(2pi) ((5/4+sin(5theta))^2)/2 dif theta=(33pi)/16
  $
  
  
]
#pagebreak()
== Luyện Tập (2025--2026)

#cau[
  Cho $D = [0,1]^2 subset RR^2$ và $f: D -> RR$ xác định bởi:
  $
    f(x,y) = cases(
      x^2 y + x y^2 & "nếu" y = x^2,
      y/(1+x^2+y^2)^(3/2) & "nếu" y != x^2.
    )
  $

  (a) Chứng tỏ $f$ khả tích trên $D$.

  (b) Tính $integral.double_D f$. Làm tròn kết quả đến 3 chữ số thập phân.
]
#loigiai[

  *a)* Ta thấy, $D=[0,1] times [0,1]$ là hình hộp, do đó $D$ đóng và bị chặn. Hơn nữa, với $(x,y)in D$. Nếu $y=x^2$, thì $0<=f(x,y)=x^2 y+x y^2 <=2$, nếu $y!= x^2$, thì $0<=f(x,y)=y/(1+x^2+y^2)^(3/2)<=1$, do đó $f$ bị chặn $forall x in D$. Hơn nữa, tập các điểm không liên tục của $f$ là 
  $
  D_f={(x,y) in D : y=x^2}
  $
  Với mỗi $x in [0,1]$ thì đường cong $y=x^2$ liên tục trên $[0,1]$, do đó $D_f$ là đồ thị hàm số ứng với đường cong trên, suy ra $D_f$ có thể tích không. Vậy, có $f$ bị chặn và tập các điểm không liên tục của $f$ có thể tích không, suy ra $f$ khả tích trên $D$.

  *b)* Với mỗi $(x,y) in D backslash D_f$, đặt $g=f=y/(1+x^2+y^2)^(3/2)$. Vì $f$ khả tích trên $D$, nên $g$ khả tích trên $D$. Hơn nữa, $V(D_f)=0$, do đó 
  $
  integral.double_D f= integral.double_D g=integral_0^1 integral_0 ^1 (y/(1+x^2+y^2)^(3/2)) dif y dif x=ln((2+sqrt(2))/(1+sqrt(3)))~0.223
  $
]
#cau[
  Cho miền phẳng $D$ nằm trong góc phần tư thứ nhất, bên ngoài hình tròn $x^2 + y^2 <= 9y$ và bên trong hình tròn $x^2 + y^2 <= 3x sqrt(3)$.

  (a) Chứng tỏ miền $D$ có diện tích.

  (b) Tính diện tích của $D$.
]
#loigiai[

  Xét hình tròn $
  Omega_1={(x,y) in RR^2 : x^2+y^2<=9 y}={(x,y)in RR^2 : x^2+(y^2-9 y+81/4)<=81/4}={(x,y)in RR^2:(x^2+(y-9/2)^2<=(9/2)^2)}
  $.

  Và hình tròn $
  Omega_2={(x,y) in RR^2: x^2+y^2-3 x sqrt(3)<=0}={(x,y) in RR^2:(x-3/2 sqrt(3))^2+y^2<=(3/2 sqrt(3))^2}
  $
]
#cau[
  Phác họa miền $E$ và tính tích phân $integral.triple_E z dif V$, trong đó $E$ là miền bị chặn bởi mặt phẳng $O x y$, mặt cong $x^2 + 4y^2 = 4$, và mặt phẳng $z = x + 2$.
]

#cau[
  Tính tích phân $integral.double_D e^(x+y) dif A$, trong đó $D$ là miền $|x| + |y| <= 1$.
]
#loigiai[

  
]
#cau[
  Một mũi khoan hình trụ có bán kính $a$ được sử dụng để khoan xuyên qua tâm quả cầu bán kính $b$ với $a < b$. Tính thể tích phần còn lại bên trong quả cầu.
]

#cau[
  Cho miền $E$ nằm bên dưới mặt phẳng $z = 2y$ và bên trên miền $D$ trong mặt phẳng Oxy bị chặn bởi đồ thị của $y = |x|$ và $y = 2$. Tính thể tích của $E$ bằng hai cách:

  (a) Thiết lập tích phân bội ba.

  (b) Sử dụng phương pháp cắt lớp.
]
#loigiai[

  *a)* Từ giả thiết, ta thấy $D$ bị chặn bởi đồ thị của $y=abs(x)$ và $y=2$, thì đơn giản miền theo chiều ngang, ta có
  $
  D={(x,y) in RR^2: 0<=y<=2,-y<=x<=y}
  $
  Mặt khác, với mỗi $x,y in D$ thì $0<=z<=2y$

  Do đó, áp dụng công thức Fubini, với miền đơn giản theo $z$. Thì ta được
  $
  integral.triple_E 1 d V=integral_0^2 integral_(-y)^y integral_0^(2y)1 dif z dif x dif y=integral_0^2 integral_(-y)^y 2 y dif x dif y=integral_0^2 4 y^2 dif y=4 [y^3/3]_0^2=32/3
  $

  *b)* Với hình minh họa $E$, ta có thể thấy nếu cắt $E$ bằng mặt phẳng $y=t$, với $t in [0,2]$, thì thiết diện ta thu được sẽ là hình chữ nhật, trong đó chiều cao ứng với $0 z$ là $2 t$ và chiều rộng ứng với $O x$ là $t-(-t)=2 t$. Vậy $S(y)=4t^2$, do đó thể tích cần tìm theo phương pháp cắt lớp là :
  $
  V=integral_0^2 4 t^2 dif t = 32/3
  $
  

]
#cau[
  Cho $E subset RR^3$ là miền bị chặn bởi đồ thị của $y = 0$, $y = 2$, $y + z = 3$, và $z = x^2$.

  Biểu diễn tích phân $integral.triple_E f$ theo ba thứ tự: $dif z dif x dif y$, $dif x dif y dif z$, và $dif y dif x dif z$.
]
#loigiai[
  Từ giả thiết, ta có thể thấy 
  $
  E={(x,y,z) in RR^3:0<=y<=2 , y+z=3,z=x^2}
  $
  Hơn nữa, giao của $2$ mặt $y+z=3$ và $z=x^2$ là $x^2+y=3 <=> y=3-x^2$. Khi đó, chiếu $E$ xuống $O x y$, ta thu được $D$ với $D$ là miền đơn giản theo phương ngang :
  $
  D={(x,y,z) in RR^2 : 0<=y<=2 ,-sqrt(3-y)<=x<=sqrt(3-y)}
  $
  Mặt khác, với mỗi $(x,y) in D$, ta đều có $x^2<=z<=3-y$. Do đó, 
  $
  integral.triple_E =integral_0^2 integral_(-sqrt(3-y))^(sqrt(3-y)) integral_(x^2)^(3-y) f dif z dif x dif y
  $
  Hơn nữa, với mỗi $(y,z)$ cố định, ta có
  $
  cases(x^2 &<=z , x&<=sqrt(3-y),x &>=-sqrt(3-y)) => -sqrt(z) <= x <=sqrt(z)
  $
  Và khi chiếu khối $E$ xuống $O y z$, ta được
  $
  D={(z,y) in RR^2 :0<=z<=3 ,0<=y<=3-z}
  $
  Vậy,
  $
  integral.triple_E =integral_0^3 integral_0^(3-z) integral_(-sqrt(z))^(sqrt(z)) f dif x dif y dif z
  $
  Hơn nữa, với mỗi $x,z$ cố định thì ta có
  $
  cases(y&<=3-z,y&<=2,y&>=0 ) => 0<=y<=min(2,3-z)
  $
  Và chiếu khối $E$ xuống Oxz,ta được
  $
  D={(x,z) in RR^2 : 0<=z<=3,-sqrt(z)<=x<=sqrt(z)}
  $
  Với mỗi $z in [0,3]$ thì $-3<=-z<=0 => 0<=3-z<=3$. Khi đó, nếu $3-z<=2$ thì $z>=1$ suy ra,
  $
  integral.triple_E f=integral_0^1 integral_(-sqrt(z))^sqrt(z) integral_0^2 f dif y dif x dif z + integral_1^3 integral_(-sqrt(z))^sqrt(z) integral_0^(3-z) f dif y dif x dif z  $

]
#cau[
  Tìm miền $E$ sao cho
  $
    integral.triple_E (4x^2 + 4y^2 + z^2 - 4) dif V
  $
  đạt cực tiểu.
]

#cau[
  Cho hàm $f$ mang giá trị thực, liên tục trên $[0,1]$. Chứng tỏ:
  $
    integral_0^1 integral_x^1 integral_x^y
    f(x) f(y) f(z) dif z dif y dif x
    = 1/6 (integral_0^1 f(x) dif x)^3.
  $
]
#loigiai[

  Vì $f$ liên tục trên $[0,1]$, do đó theo công thức Newton-Leibniz, thì $
  F(x)=integral_0^x f(t) dif t => F'(x)=f(x)
  $
  Do đó, nếu đặt $integral_y ^ x f(z) dif z=F(Y)-F(x)$
, suy ra
$
integral_0^1 integral_x ^1 (F(Y)-F(X)) dif y dif x&=integral_0^1 integral_x^1 F'(y) (F(y)-F(x)) dif y dif x\
&=integral_0^1  f(x) [1/2 (F(y)-F(x))^2]_x^1 dif x \
&= integral_0^1 f(x) 1/2(F(1)-F(x))^2 dif x\
&=integral_0^1 1/2 f(x)(F(x)-F(1))^2 dif x=integral_0^1 1/2 times 1/3 dif(F(x)-F(1))^3 =1/6 (integral_0^1 f(x) dif x)^3
$
  
]