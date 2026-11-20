
 #import "@preview/euler-math:0.1.0": *

// ==========================================
// CÀI ĐẶT MÀU SẮC & BIẾN ĐẾM
// ==========================================
#let color-prop = rgb("#009688")  // Xanh ngọc (Mệnh đề) - nổi bật
#let bg-prop = rgb("#e0f2f1")     // Nền xanh ngọc nhạt

#let color-thm = rgb("#c00040")   // Đỏ thẫm (Định lí)
#let bg-thm = rgb("#fdf2f4")

#let color-lem = rgb("#2e7d32")   // Xanh lá (Bổ đề)
#let bg-lem = rgb("#e8f5e9")

#let color-cau = rgb("#B4A0CB")   // Đỏ nâu
#let bg-cau = rgb("#F8F5FC")
#let color-prob = rgb("#006080")  // Xanh lam (Bài toán)
#let bg-prob = rgb("#f0f7fb")

#let color-def = rgb("#6a0dad")   // Tím (Định nghĩa)
#let bg-def = rgb("#f8f1fa")

#let color-ex = rgb("#d96600")    // Cam (Ví dụ)
#let bg-ex = rgb("#fff5eb")

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
  if title != none {
    align(center + horizon)[
      #text(size: 22pt, weight: "bold")[#title] \
      #v(1em)
      #if subtitle != none {
        text(size: 15pt, weight: "bold")[#subtitle] 
      }
      #v(2em)
      #if author != none {
        text(size: 11pt)[#author]
      }
    ]
    pagebreak()
  }

  body
}

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
      stroke: (left: 3pt + color),
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
  title: "Đại Số Đại Cương",
  subtitle: "Bài Tập",
  author: "Nguyễn Minh Huy - Võ Tuấn Khương"
)



// Gọi lại Mục lục ở đây 
#heading(numbering: none, outlined: false)[Mục lục]
#outline(title: none)
#pagebreak()
= Nhóm
#baitoan[
  Trong các trường hợp sau hãy xét xem cấu trúc $(G,*)$ có là nửa nhóm, vị nhóm hay nhóm không, và xét tính giao hoán của chúng. Trong trường hợp $(G,*)$ là nhóm, hãy mô tả tất cả các phần tử có cấp hữu hạn của nhóm này.

  a) $G=QQ \\ {-6},x*y=90x y+540x +540y+3234$.
  
  b) $G=RR^+ \\{1},x*y=x^(ln y)$.

  c) $G=RR,x*y=root(n,x^n+y^n)$, trong đó $n$ là số nguyên dương lẻ cho trước.

  d) $G=RR,x*y=(root(n,x)+root(n,y))^n$, trong đó $n$ là số nguyên dương lẻ cho trước.

  e) $G=RR^+,x*y=ln(e^x+e^y-1)$

  f)$G=RR times RR ,(x,y)*(z,t)=(x+y z,y t)$ 

  g) $G=RR times RR^*,(x,y)*(z,t)=(x z- y t,x t +y z)$

  h) $G=RR^2 \\{(0,0)},(x,y)&*(z,t)=(x z - y t,x t+ y z)$
]

#loigiai[
  
  #y("a")
  
  *Đóng* 
  
  Xét $G=QQ \\ {-6}$ , khi đó lấy tùy ý $x,y in G$, có $
  x*y=90x y +540x +540y+3234=90(x+6)(y+6)-6
  $ 
  Vì $x,y in G$, nên $(x+6)(y-6) !=0$, do đó $x*y !=-6$, hay $x*y in G$. $quad (1)$

  *Kết Hợp* 
  
  Lấy tùy ý $x,y,z in G$, có $(x*y)*z=90(x*y+6)(z+6)-6=8100(x+6)(y+6)(z+6)-6=x*(y*z)$. $quad (2)$

  *Trung Hòa* 
  
  Với $e in G$, xét tùy ý $x in G$, giả sử $x*e=x$ hay $
  90(x+6)(e+6)=x+6 => e=-539/90 in G
  $
  Do đó, chọn $e=-539/90$, thì $forall x in G,x*e=x$ $quad(3)$

  *Khả Đối Xứng* 
  
  Với $x,y in G$, xét $x*y=e$ hay $
  x*y=90(x+6)(y-6)-6=-539/90 => y=1/(8100 (x+6))-6 in G quad(4)
  $ 

  *Giao Hoán* 
  
  Với $x,y in G$, xét $x*y=90(x+6)(y+6)-6=90(y+6)(x+6)-6=y*x$ $quad (5)$  

  Từ $(1),(2),(3),(4),(5)$ suy ra $(G,*)$ là nhóm abel.

  *Phần Tử Hữu Hạn*

  Gọi $x^(*m)=underbrace(x*x*dots*x,m " lần")$. Bằng quy nạp, ta có
$
x^(*m)+6=90^(m-1)(x+6)^m.
$
Do đó $x$ có cấp hữu hạn khi và chỉ khi tồn tại $m in NN^+$ sao cho $x^(*m)=e=-539/90$. Khi đó
$
x^(*m)=e
<=> 90^(m-1)(x+6)^m=1/90
<=> [90(x+6)]^m=1.
$
Vì $90(x+6) in QQ$, nên tồn tại $m in NN^+$ thỏa $[90(x+6)]^m=1$ khi và chỉ khi
$
90(x+6)=1 quad "hoặc" quad 90(x+6)=-1.
$
Do đó
$
x=-539/90 quad "hoặc" quad x=-541/90.
$
Vậy các phần tử có cấp hữu hạn của $(G,*)$ là $-539/90$ và $-541/90$, trong đó
$op("ord")(-539/90)=1,
op("ord")(-541/90)=2.
$
]

#pagebreak()
  #y("b")

  *Đóng* 
  
  Xét $G=RR^+ \\ {1}$. Lấy tùy ý $x,y in G$, vì $x>0$ nên $x*y=x^(ln y)>0$. 
  
  Nếu $x*y=1$ thì $x^(ln y)=1$. Vì $x != 1$, suy ra $ln y=0$, hay $y=1$, mâu thuẫn với $y in G$. Do đó $x*y in G$. $quad (1)$

  *Kết Hợp* 
  
  Lấy tùy ý $x,y,z in G$, có $(x*y)*z=(x^(ln y))^(ln z)=x^((ln y)(ln z))$, và $x*(y*z)=x^(ln(y^(ln z)))=x^((ln y)(ln z))$. Do đó $(x*y)*z=x*(y*z)$. $quad (2)$

  *Trung Hòa* 
  
  Với $e in G$, xét $x*e=x$, ta có $x^(ln e)=x$. Vì $x != 1$, suy ra $ln e=1$, hay $e=e^1$. Mặt khác $e^1*x=(e^1)^(ln x)=x$. Do đó phần tử trung hòa là $e=e^1$. $quad (3)$

  *Khả Đối Xứng* 
  
  Với $x in G$, xét $x*y=e$, ta có $x^(ln y)=e^1 => (ln x)(ln y)=1 => ln y=1/(ln x)$, do đó $y=e^(1/(ln x)) in G$. Vậy mọi phần tử đều khả nghịch. $quad (4)$

  *Giao Hoán* 
  
  Với $x,y in G$, ta có $x*y=x^(ln y)=e^((ln x)(ln y))=e^((ln y)(ln x))=y^(ln x)=y*x$. $quad (5)$

  Từ $(1),(2),(3),(4),(5)$ suy ra $(G,*)$ là nhóm abel.

  *Phần Tử Hữu Hạn* 
  
  Gọi $x^(*m)=underbrace(x*x*dots*x,m " lần")$. Ta có $ln(x^(*m))=(ln x)^m$. Do đó
  $
  x^(*m)=e <=> (ln x)^m=1.
  $
  Suy ra $ln x=1$, hoặc $ln x=-1$ khi $m$ chẵn. Vậy các phần tử có cấp hữu hạn là $e^1$ và $e^(-1)$, trong đó $op("ord")(e^1)=1$ và $op("ord")(e^(-1))=2$.


  #y("c")

  *Đóng* 
  
  Xét $G=RR$. Với mọi $x,y in G$, vì $n$ là số nguyên dương lẻ nên $x*y=root(n,x^n+y^n) in RR$. Do đó phép toán đóng trên $G$. $quad (1)$

  *Kết Hợp* 
  
  Với mọi $x,y,z in G$, có $(x*y)*z=root(n,(x*y)^n+z^n)=root(n,x^n+y^n+z^n)$ 
  
  và $x*(y*z)=root(n,x^n+(y*z)^n)=root(n,x^n+y^n+z^n)$. Do đó $(x*y)*z=x*(y*z)$. $quad (2)$

  *Trung Hòa* 
  
  Ta có $x*0=root(n,x^n)=x$ và $0*x=x$, vì $n$ lẻ. Vậy phần tử trung hòa là $e=0$. $quad (3)$

  *Khả Đối Xứng* 
  
  Với $x in G$, do $n$ lẻ nên $x*(-x)=root(n,x^n+(-x)^n)=0$. Do đó nghịch đảo của $x$ là $-x$. $quad (4)$

  *Giao Hoán* 
  
  Với mọi $x,y in G$, $x*y=root(n,x^n+y^n)=root(n,y^n+x^n)=y*x$. $quad (5)$

  Từ $(1),(2),(3),(4),(5)$ suy ra $(G,*)$ là nhóm abel.

  *Phần Tử Hữu Hạn* 
  
  Ta có $x^(*m)=root(n,m x^n)$. Do đó $x^(*m)=e <=> root(n,m x^n)=0 <=> x=0$. Vậy phần tử duy nhất có cấp hữu hạn là $0$, với $op("ord")(0)=1$.


  #y("d")

  *Đóng* 
  
  Xét $G=RR$. Với mọi $x,y in G$, vì $n$ là số nguyên dương lẻ nên $x*y=(root(n,x)+root(n,y))^n in RR$. Do đó phép toán đóng trên $G$. $quad (1)$

  *Kết Hợp* 
  
  Vì $n$ lẻ nên $root(n,(root(n,x)+root(n,y))^n)=root(n,x)+root(n,y)$. Do đó $(x*y)*z=(root(n,x)+root(n,y)+root(n,z))^n=x*(y*z)$. $quad (2)$

  *Trung Hòa* 
  
  Ta có $x*0=(root(n,x)+root(n,0))^n=x$ và $0*x=x$. Vậy phần tử trung hòa là $e=0$. $quad (3)$

  *Khả Đối Xứng* 
  
  Với $x in G$, do $n$ lẻ nên $root(n,-x)=-root(n,x)$. Vì vậy $x*(-x)=(root(n,x)-root(n,x))^n=0$. Do đó nghịch đảo của $x$ là $-x$. $quad (4)$

  *Giao Hoán* 
  
  Với mọi $x,y in G$, $x*y=(root(n,x)+root(n,y))^n=(root(n,y)+root(n,x))^n=y*x$. $quad (5)$

  Từ $(1),(2),(3),(4),(5)$ suy ra $(G,*)$ là nhóm abel.

  *Phần Tử Hữu Hạn* 
  
  Ta có $x^(*m)=(m root(n,x))^n=m^n x$. Do đó $x^(*m)=e <=> m^n x=0 <=> x=0$. Vậy phần tử duy nhất có cấp hữu hạn là $0$, với $op("ord")(0)=1$.


  #y("e")

  *Đóng* 
  
  Xét $G=RR^+$. Với mọi $x,y in G$, ta có $e^x>1$ và $e^y>1$, do đó $e^x+e^y-1>1$. Suy ra $x*y=ln(e^x+e^y-1)>0$, hay $x*y in G$. $quad (1)$

  *Kết Hợp* 
  
  Ta có $e^(x*y)=e^x+e^y-1$. Do đó $(x*y)*z=ln(e^(x*y)+e^z-1)=ln(e^x+e^y+e^z-2)$, và $x*(y*z)=ln(e^x+e^(y*z)-1)=ln(e^x+e^y+e^z-2)$. Vậy $(x*y)*z=x*(y*z)$. $quad (2)$

  *Trung Hòa* 
  
  Giả sử tồn tại $u in G$ là phần tử trung hòa. Khi đó $x*u=x$, suy ra $ln(e^x+e^u-1)=x => e^u=1 => u=0$. Nhưng $0 not in RR^+$, nên $(G,*)$ không có phần tử trung hòa.

  *Giao Hoán* 
  
  Với mọi $x,y in G$, $x*y=ln(e^x+e^y-1)=ln(e^y+e^x-1)=y*x$.

  Vậy $(G,*)$ là nửa nhóm giao hoán, nhưng không phải vị nhóm và do đó không phải nhóm.


  #y("f")

  *Đóng* 
  
  Xét $G=RR times RR$. Với mọi $(x,y),(z,t) in G$, có $(x,y)*(z,t)=(x+y z,y t) in RR times RR$. Do đó phép toán đóng trên $G$. $quad (1)$

  *Kết Hợp* 
  
  Với $(x,y),(z,t),(u,v) in G$, ta có $((x,y)*(z,t))*(u,v)=(x+y z,y t)*(u,v)=(x+y z+y t u,y t v)$, và $(x,y)*((z,t)*(u,v))=(x,y)*(z+t u,t v)=(x+y z+y t u,y t v)$. Do đó phép toán có tính kết hợp. $quad (2)$

  *Trung Hòa* 
  
  Ta có $(x,y)*(0,1)=(x,y)$ và $(0,1)*(x,y)=(x,y)$. Do đó phần tử trung hòa là $e=(0,1)$. $quad (3)$

  *Khả Đối Xứng* 
  
  Xét $(x,0) in G$. Với mọi $(z,t) in G$, ta có $(x,0)*(z,t)=(x,0) != (0,1)$, nên $(x,0)$ không có phần tử nghịch đảo. Do đó $(G,*)$ không phải nhóm.

  *Giao Hoán* 
  
  Chẳng hạn $(0,2)*(1,1)=(2,2)$, trong khi $(1,1)*(0,2)=(1,2)$. Do đó phép toán không giao hoán.

  Vậy $(G,*)$ là một vị nhóm không giao hoán, nhưng không phải nhóm.


  #y("g")

  *Đóng* 
  
  Xét $G=RR times RR^*$. Lấy $(1,1),(1,-1) in G$, ta có $(1,1)*(1,-1)=(1-(-1),-1+1)=(2,0)$. Nhưng $(2,0)  in.not RR times RR^*$, do đó phép toán không đóng trên $G$.

  Vậy $(G,*)$ không phải nửa nhóm, không phải vị nhóm và cũng không phải nhóm.


  #y("h")

  *Đóng*
  
  Xét $G=RR^2 \\ {(0,0)}$. Với $(x,y),(z,t) in G$, ta có $(x,y)*(z,t)=(x z-y t,x t+y z)$. Giả sử $(x z-y t,x t+y z)=(0,0)$, khi đó $(x z-y t)^2+(x t+y z)^2=0$. Nhưng
  $
  (x z-y t)^2+(x t+y z)^2=(x^2+y^2)(z^2+t^2)>0,
  $
  vì $(x,y) != (0,0)$ và $(z,t) != (0,0)$, mâu thuẫn. Do đó $(x,y)*(z,t) != (0,0)$, hay phép toán đóng trên $G$. $quad (1)$

  *Kết Hợp* 
  
  Với $(x,y),(z,t),(u,v) in G$, ta có
  $
  ((x,y)*(z,t))*(u,v)=(x z u-y t u-x t v-y z v,x z v-y t v+x t u+y z u),
  $
  trong khi
  $
  (x,y)*((z,t)*(u,v))=(x z u-x t v-y z v-y t u,x z v+x t u+y z u-y t v).
  $
  Hai biểu thức bằng nhau, do đó phép toán có tính kết hợp. $quad (2)$

  *Trung Hòa* 
  
  Ta có $(x,y)*(1,0)=(x,y)$ và $(1,0)*(x,y)=(x,y)$. Do đó phần tử trung hòa là $e=(1,0)$. $quad (3)$

  *Khả Đối Xứng* 
  
  Với $(x,y) in G$, đặt
  $
  (z,t)=(x/(x^2+y^2),-y/(x^2+y^2)).
  $
  Khi đó $(x,y)*(z,t)=(1,0)$. Do đó
  $
  (x,y)^(-1)=(x/(x^2+y^2),-y/(x^2+y^2)).
  $
  $quad (4)$

  *Giao Hoán* 
  
  Với mọi $(x,y),(z,t) in G$, ta có $(x,y)*(z,t)=(x z-y t,x t+y z)=(z x-t y,z y+t x)=(z,t)*(x,y)$. $quad (5)$

  Từ $(1),(2),(3),(4),(5)$ suy ra $(G,*)$ là nhóm abel.

  *Phần Tử Hữu Hạn* 
  
  Với $(x,y) in G$, đặt $x=r cos theta$, $y=r sin theta$, với $r>0$. Khi đó
  $
  (x,y)^(*m)=(r^m cos(m theta),r^m sin(m theta)).
  $
  Phần tử $(x,y)$ có cấp hữu hạn khi và chỉ khi tồn tại $m in NN^+$ sao cho $(x,y)^(*m)=(1,0)$, tương đương $r^m=1$ và $m theta=2k pi$ với $k in ZZ$. Vì $r>0$, suy ra $r=1$ và $theta/(2 pi) in QQ$.

  Vậy tất cả các phần tử có cấp hữu hạn là
  $
  { (cos(2 pi q),sin(2 pi q)) | q in QQ }.
  $
  Nếu $q=k/m$, với $op("gcd")(k,m)=1$ và $m>0$, thì
  $
  op("ord")((cos(2 pi k/m),sin(2 pi k/m)))=m.
  $
  #baitoan[
    *a)* Chứng minh rằng một nửa nhóm khác rỗng, hữu hạn là nhóm khi và chỉ khi phép
toán tương ứng có tính giản ước. Chỉ ra rằng điều kiện hữu hạn không thể bỏ được.

*b)* Chứng minh rằng mọi tập con khác rỗng, hữu hạn, kín đối với phép toán tương ứng
trong một nhóm đều là các nhóm con của nhóm đó.
  ]
  #loigiai[
    
    *(a)* 
    Xét $G$ với phép toán $(*)$ là nửa nhóm khác rỗng, hữu hạn.

    $(==>)$ Giả sử $(G,*)$ là nhóm khi đó hiển nhiên phép toán $(*)$ có tính giản ước.

    $(<==)$ Giả sử phép toán $(*)$ có tính giản ước, ta chứng minh $(G,*)$ là nhóm, hay chứng minh rằng với mọi $a,b in G$ , các phương trình $a x=b, y a=b$ đều có nghiệm trong G. Thật vậy, xét ánh xạ 
    $
    phi: G -> G , phi(x)=a x
    $
    Ta thấy $phi$ là đơn ánh, thật vậy do tính giản ước của $(*)$, ta có, với tùy ý $x,y in G$, giả sử
    $
    phi(x)=phi(y) => a x= a y => x=y
    $
    Hơn nữa , do $G$ hữu hạn nên $phi$ cũng là toàn ánh, do đó $phi$ là song ánh, hay phương trình $a x=b$ luôn có nghiệm trong $G$. Tương tự, ta xét ánh xạ $f: G -> G, f(y)=y a$, khi đó ta có $f$ là song ánh, suy ra phương trình $y a =b $ luôn có nghiệm trong $G$. Do đó, $(G,*)$ là nhóm.

    Giả thiết $G$ hữu hạn không thể bỏ được. Thật vậy , xét nửa nhóm vô hạn $(NN,+)$ , ta thấy phép toán $(+)$ có tính giản ước trong $NN$ nhưng $(NN,+)$ không là nhóm.
    
    *(b)* Đặt $(G,*)$ là một nhóm khác rỗng, với $H subset G$, $H != emptyset,|H|!=infinity$, kín với phép toán $(*)$, ta chứng minh $H<=G$.

    Gọi $e$ là phần tử trung hòa của $G$, ta chứng minh $e in H$. Ta có nhận xét sau, vì $H$ kín với phép toán $(*)$, nên với tùy ý $x in H$ dãy $(x,x^2,x^3,dots) in H$ , vì dãy trên vô hạn mà $H$ hữu hạn, nên theo nguyên lý Dirichlet, tồn tại $n<m$ sao cho $
    x^n=x^m quad (1)
    $
    Vì $x in H, H subset G => x in G => x^n in G => exists (x^n)^(-1) : x^n*(x^n)^(-1)=e$, do đó, nhân $2$ vế của $(1)$ cho $(x^n)^(-1)$, ta được
    $
    e=x^(m-n) quad (2)
    $
    Do $m-n>0$, nên $x^(m-n) in H$, do đó $e in H$.

    Với tùy ý $x in H$, ta chứng minh $x^(-1) in H$, thật vậy, có $(2) <=> e=x*x^(m-n-1)$. 
    
    Nếu $m-n=1$, thì $e=x*e => x^(-1)=e$.

    Nếu $m-n>1$, thì $x^(m-n-1) in G$, do đó $x^(-1)=x^(m-n-1)=x^(-1)in G$. Do đó, với tùy ý $x,y in H$, ta đều có $x^(-1)y in H$. Vậy $H<= G$
    
]
#baitoan[

  Cho $(X, dot)$ là một nửa nhóm khác rỗng. Với mỗi $a in X$ ta đặt

$
a X = {a x | x in X};
$

$
X a = {x a | x in X}.
$

Chứng minh các khẳng định sau là tương đương:

*a)* $(X, dot)$ là nhóm;

*b)* Với mọi $a in X$, $a X = X a = X$.
]
#loigiai[
*a)* $==> $ *b)* Giả sử $(X, dot)$ là một nhóm. Với mọi $a in X$, do $X$ đóng đối với phép toán nên $a X subset.eq X$. Ngược lại, với tùy ý $x in X$, vì $a^(-1) x in X$ nên
$
x = a(a^(-1)x) in a X.
$
Suy ra $X subset.eq a X$, do đó $a X = X$. Tương tự, vì $x a^(-1) in X$ nên
$
x = (x a^(-1))a in X a,
$
suy ra $X a = X$. Vậy với mọi $a in X$,
$
a X = X a = X.
$

*b)* $==> $ *a)* Giả sử với mọi $a in X$, ta có
$
a X = X a = X.
$
Ta chứng minh $(X, dot)$ là một nhóm. Do $X != emptyset$, lấy $a in X$. Vì $a in X = a X$, tồn tại $e_r in X$ sao cho
$
a e_r = a quad (1)
$
Với tùy ý $x in X$, do $X a = X$ nên tồn tại $y in X$ sao cho $x = y a$. Do đó, từ (1),
$
x e_r = (y a)e_r = y(a e_r) = y a = x.
$
Vậy $e_r$ là phần tử đơn vị phải của $X$.

Tương tự, vì $a in X = X a$, tồn tại $e_l in X$ sao cho
$
e_l a = a quad (2)
$
Với tùy ý $x in X$, do $a X = X$ nên tồn tại $y in X$ sao cho $x = a y$. Khi đó
$
e_l x = e_l(a y) = (e_l a)y = a y = x.
$
Vậy $e_l$ là phần tử đơn vị trái của $X$. Do đó
$
e_l = e_l e_r = e_r.
$
Đặt $e = e_l = e_r$, suy ra với mọi $x in X$,
$
e x = x e = x.
$

Bây giờ, với tùy ý $x in X$, do $x X = X$ và $X x = X$, tồn tại $y,z in X$ sao cho
$
x y = e, quad z x = e.
$
Khi đó
$
z = z e = z(x y) = (z x)y = e y = y.
$
Suy ra
$
x y = y x = e,
$
nên $y = x^(-1) in X$. Vậy mọi phần tử của $X$ đều có phần tử nghịch đảo. Do $(X, dot)$ là một nửa nhóm, suy ra $(X, dot)$ là một nhóm.

Vậy
$
(X, dot) " là nhóm" <=> forall a in X, quad a X = X a = X.
$
]
#baitoan[
  Cho nhóm $(G, .)$ và $a in G$. Trên $G$ ta định nghĩa phép toán $(*)$ như sau: $
  forall x, y ∈ G, x∗y =
x a y.
$ Chứng minh rằng $(G, ∗)$ cũng là nhóm.
]
#loigiai[
  
  *Kết Hợp* : Lấy tùy ý $x,y,z in G$, có $(x*y)*z=(x*y) a z=x a y a z$, hơn nữa có $x*(y*z)=x a (y *z)=x a y a z=(x*y)*z quad (1)$

  *Trung Hòa* : Tìm $e_* in G$, sao cho với bất kỳ $x in G $, thì $x*e_*=x$ hay $x a e_* =x$, do $=> a e_* =e$, do đó, $e_*= a^(-1)e=a^(-1) quad (2)$

  *Khả đối xứng* : Với bất kỳ $x in G$, tìm $y in G$, sao cho $x*y = e$, hay $x a y= a^(-1)$, chọn $y=a^(-1)x^(-1)a^(-1) =x^(-*) quad (3)$

  Từ $(1),(2),(3)$ suy ra $(G,*)$ là nhóm
]
#baitoan[
  Cho $G$ là một nhóm trong đó có duy nhất một phần tử $a$ có cấp $2$. Chứng minh rằng $forall x in G,a x=x a$.
]
#loigiai[
Lấy tùy ý $x in G$. Vì $op("ord")(a) = 2$ nên $a^2 = e$ và $a != e$. Xét phần tử $x a x^(-1)$, ta có
$
(x a x^(-1))^2
= x a x^(-1) x a x^(-1)
= x a^2 x^(-1)
= x e x^(-1)
= e.
$
Mặt khác, $x a x^(-1) != e$, vì nếu $x a x^(-1) = e$ thì suy ra $a = e$, mâu thuẫn với $op("ord")(a) = 2$. Do đó
$
op("ord")(x a x^(-1)) = 2.
$
Vì $a$ là phần tử duy nhất có cấp $2$ trong $G$, suy ra
$
x a x^(-1) = a.
$
Nhân hai vế bên phải với $x$, ta được
$
x a = a x.
$
Vậy với mọi $x in G$,
$
a x = x a.
$
]
#baitoan[
  Cho $G$ là một nhóm mà mọi phần tử khác $e$ đều có cấp $2$. Chứng minh $G$ giao hoán
]
#loigiai[
  Lấy tùy ý $x,y in G$, ta chứng minh $x y= y x$, từ giả thiết, ta có $x^(-1)=x$ và $y^(-1)=y$.Đặt $k=x y$, thì $k in G$, do đó $k^(-1)=k$ => $k^(-1)=(x y)^(-1)=y^(-1) x^(-1)=y x=k=x y$.
]
#baitoan[
  Cho nhóm $(G, dot)$. Trên $G$ ta định nghĩa một quan hệ $~$ như sau:

$
forall x, y in G, x ~ y <=> exists a in G, x = a^(-1) y a.
$

Chứng minh rằng

*a)* $~$ là quan hệ tương đương trên $G$;

*b)* $~$ là quan hệ thứ tự trên $G$ khi và chỉ khi $G$ giao hoán.
]
#loigiai[
  *a)* Ta chứng minh $~$ phản xạ, đối xứng, bắc cầu.
  
  *Phản xạ* : Lấy tùy ý $x in G$, ta chứng minh $x ~ x$ hay $exists a in G : x= a^(-1)x a$, chọn $a= e in G$ ta có điều phải chứng minh. $quad (*)$ 

  *Đối Xứng*: Lấy tùy ý $x,y in G$, ta chứng minh $x ~y=y~x$, có $x~y: exists a in G : x=a^(-1)y a <=> y = a x a^(-1)$, chọn $b=a^(-1)$ thì $y~x quad (**)$

  *Bắc Cầu* : Cho trước $x,y,z in G$, ta chứng minh $x~y,y~z => x~z$, hay tìm $a in G$ sao cho $x=a^(-1)z a$. Có $
  x~y => exists a_1 in G : x=a_1^(-1)y a_1 quad(1)
  $
  Có $
  y~z=> exists a_2 in G : y=a_2^(-1)z a_2 quad (2)
  $
  Từ $(1),(2)$ suy ra,
  $
  x=a_1^(-1)a_2^(-1)z a_2 a_1
  $
  Do đó, chọn $a= a_2 a_1 quad (***)$

  Từ $(*),(**),(***)$ suy ra $~$ là quan hệ tương đương trên $G$.

  *b)* 
  
  $(==>)$
  Giả sử $~$ là quan hệ thứ tự trên $G$, ta chứng minh $G$ giao hoán, nghĩa là : $forall x,y in G: x y = y x$.
  
  Với tùy ý $a,y in G $ 
  Đặt $x=a^(-1)y a => x~y$ mà do $~$ là quan hệ tương đương, do đó $y~x$ hơn nữa, do $~$ là quan hệ thứ tự , do đó $x=y$ , suy ra
  $y=a^(-1)y a => a y = y a$, hay $G$ có tính giao hoán.

  $(<==)$ Giả sử $G$ giao hoán, ta chứng minh $~$ là quan hệ thứ tự, từ câu $a)$, ta có $~$ có tính phản xạ, bắc cầu, ta chứng minh $~$ có tính phản đối xứng.

  Thật vậy, cho trước $x,y in G$, giả sử $x~y$ và $y~x$ ta chứng minh $x=y$. Vì $x~y $ nên $exists a in G: x=a^(-1)y a$, do $G$ giao hoán nên $y a = a y$ do đó, $x=a^(-1) a y = y$, vậy $x=y$
 
]

#baitoan[
  Cho nhóm $(G,.)$. Giả sử tồn tại ba số nguyên $i$ liên tiếp sao cho với mọi $x,y in G$, $(x y)^i=x^i y^i$. Chứng minh rằng $G$ giao hoán.
]
#loigiai[
  
  Gọi ba số nguyên $i$ liên tiếp là $i,i+1,i+2$, vì $(x y)^i=x^i y^i$ nên ta có $
  (x y)^(i+1)=x^(i+1)y^(i+1) quad (1)
  $ 
  và $
  (x y)^(i+2)=x^(i+2) y^(i+2) quad (2)
  $.

  Ta chứng minh, lấy tùy ý $x,y in G$, $x y = y x$. Thật vậy, từ $(1)$, ta có
  $
  (x y)^(i+1)=(x y)^i (x y)=x^i y^i x y=x^(i+1)y^(i+1)=x^i x y^i y
  $
  Suy ra , $y^i x=x y^i quad (*)$
  
  Từ $(2)$, ta có
  $
  (x y)^(i+2)=(x y)^(i+1)(x y)=x^(i+1) y^(i+1) x y =x^(i+2) y^(i+2)
  $
  Suy ra, $y^(i+1)x=x y^(i+1)$ , từ $(*)$ ta có $y^(-i) x=x y^(-i)$

  Do đó, $y x =y^(-i) y^(i+1) x=y^(-i) x y^(i+1)=x y^(-i) y^(i+1)=x y$, vậy ta có điều phải chứng minh.
]
#baitoan[
  Chứng minh rằng nếu $(G,.)$ là một nhóm giao hoán có đúng $n$ phần tử khác nhau là $x_1,x_2,dots,x_n$ thì $(x_1 x_2 dots x_n)^2=e$.
]
#loigiai[
  Giả sử $(G,.)$ là một nhóm giao hoán có đúng $n$ phần tử khác nhau là $x_1,x_2,dots,x_n$. Khi đó, đặt $P=(x_1 dots x_n)$. Xét $P^2=(x_1 dots x_n)(x_1 dots x_n)=(x_1^2 dots x_n^2)$. Ta chứng minh, với bất kỳ $i in {1,2,dots n}$ thì $x_i^(-1)=x_i$, thật vậy với $i != j$ giả sử $x_i^(-1)=x_j^(-1) <=> x_i = x_j$, mâu thuẫn do $x_1,x_2, dots x_n$ đôi một khác nhau, do đó với $i != j$ thì luôn có $x_i^(-1)!=x_j^(-1)$. Do đó, tập ${x_1^(-1),x_2^(-1),dots,x_n^(-1)}={x_1,x_2,dots,x_n}$ do $|G|=n$. Suy ra,
  $
  P^2=(x_1 x_1^(-1))(x_2 x_2^(-1)) dots(x_n x_n^(-1))=e
  $

]
#baitoan[
  Chứng minh rằng trong nhóm hoán vị $S_n$, nếu một hoán vị có cấp lẻ thì đó phải là
một hoán vị chẵn. Xét chiều đảo.
]
#loigiai[
  Xét nhóm hoán vị $S_n$, giả sử có một hoán vị có cấp lẻ, nghĩa là $sigma^(2k+1)=I_d$, suy ra $s g n(sigma)^(2k+1)=1$, do đó $s g n(sigma)=1$ hay sigma là một hoán vị chẵn.Chiều đảo không đúng: Trong nhóm hoán vị $S_7$, xét $σ$ = $(1 2)(3 4)(5 6 7)$.Dễ
thấy $sigma$ là một hoán vị chẵn và $sigma$ có cấp $6$ cũng là một số chẵn.
]
#baitoan[
Trong nhóm hoán vị $S_10$, xét các phép hoán vị
$
sigma_1 = mat(
  1, 2, 3, 4, 5, 6, 7, 8, 9, 10;
  2, 3, 5, 7, 6, 1, 8, 4, 10, 9
);
$
$
sigma_2 = mat(1, 3, 4, 7)mat(2, 5)mat(1 ,2, 4, 3).
$

*a)* Viết $sigma_1$ và $sigma_2$ dưới dạng tích các chu trình rời nhau và dưới dạng tích các chuyển vị. Suy ra tính chẵn, lẻ và cấp của chúng.

*b)* Viết $sigma_1 sigma_2$; $sigma_2^2$; $sigma_2^(-1)$; $sigma_2^(-2)$; $sigma_1^2 sigma_2$; $sigma_1 sigma_2^2$ dưới dạng tích các chu trình rời nhau. Xét tính chẵn, lẻ và cấp của chúng.

*c)* Tìm $sigma in S_n$ thỏa $sigma_1 sigma sigma_2^(-2) = sigma_1^3$.
]
#loigiai[
  
  *a)*
 Xét$ sigma_1 &= mat(
  1, 2, 3, 4, 5, 6, 7, 8, 9, 10;
  2, 3, 5, 7, 6, 1, 8, 4, 10, 9
)\
 &=mat(1 ,2,3,5,6) mat(4,7,8) mat(9, 10)\
&=mat(1,6)mat(1,5)mat(1,3)mat(1,2)mat(4,8)mat(4,7)mat(9,10)
$
Xét 
$
sigma_2&=mat(1,3,4,7)mat(2,5)mat(1,2,4,3)\
&=mat(1,2,3,4,5,6,7,8,9,10;5,7,3,4,2,6,1,8,9,10)=mat(1,5,2,7)
\
&=mat(1,7)mat(1,2)mat(1,5)
$
Suy ra, $sigma_1,sigma_2$ đều  là các hoán vị lẻ, hơn nữa ord$(sigma_1)=lcm(5,3,2)=30$ và ord($sigma_2$)=4.

*b)*
$
sigma_1 sigma_2
&= mat(1,2,3,5,6) mat(4,7,8) mat(9,10) mat(1,5,2,7)
\
&= mat(1,6) mat(2,8,4,7) mat(3,5) mat(9,10)
\
&= mat(1,6) mat(2,7) mat(2,4) mat(2,8) mat(3,5) mat(9,10),
$

$
sigma_2^2
= mat(1,5,2,7)^2
= mat(1,2) mat(5,7),
$

$
sigma_2^(-1)
= mat(7,2,5,1)
= mat(1,5) mat(1,2) mat(1,7),
$

$
sigma_2^(-2)
= mat(1,2) mat(5,7),
$

$
sigma_1^2 sigma_2
&= mat(1,2,3,5,6)^2 mat(4,7,8)^2 mat(9,10)^2 mat(1,5,2,7)
\
&= mat(1,3,6,2,5) mat(4,8,7) mat(1,5,2,7)\
&= mat(2,4,8,7,3,6)
\
&= mat(2,6) mat(2,3) mat(2,7) mat(2,8) mat(2,4),
$

$
sigma_1 sigma_2^2
&= mat(1,2,3,5,6) mat(4,7,8) mat(9,10) mat(1,2) mat(5,7)
\
&= mat(1,3,5,8,4,7,6) mat(9,10)
\
&= mat(1,6) mat(1,7) mat(1,4) mat(1,8) mat(1,5) mat(1,3) mat(9,10).
$

Suy ra:

 $sigma_1 sigma_2$, $sigma_2^2$, $sigma_2^(-2)$ là các hoán vị chẵn,
$o(sigma_1 sigma_2)=4$, $o(sigma_2^2)=2$, $o(sigma_2^(-2))=2$;

$sigma_2^(-1)$, $sigma_1^2 sigma_2$, $sigma_1 sigma_2^2$ là các hoán vị lẻ và
 $o(sigma_2^(-1))=4$, $o(sigma_1^2 sigma_2)=6$, $o(sigma_1 sigma_2^2)=14$.

*c)* Tìm $sigma in S_n$ thỏa $sigma_1 sigma sigma_2^(-2)=sigma_1^3$.

Có $
sigma_1 sigma sigma_2^(-2) = sigma_1^3
<=> sigma = sigma_1^2 sigma_2^2
= (sigma_1^2 sigma_2) sigma_2
= mat(2,4,8,7,3,6) mat(1,5,2,7)
\
= mat(1,5,4,8,7) mat(2,3,6).
$
]
#baitoan[
  Cho $sigma$ và $tau$ là hai hoán vị rời nhau trong $S_n$. Chứng minh rằng $(sigma tau)^k=sigma^k tau^k,forall k in NN$.
]
#loigiai[

  *Cách 1* : 
  
  Từ giả thiết, ta có $sigma tau=tau sigma$. Xét
  $
  (sigma tau)^k=underbrace((sigma tau) (sigma tau) dots (sigma tau),"k lần")= sigma tau sigma tau dots sigma tau = underbrace((sigma sigma sigma),"k lần") underbrace((tau tau tau),"k lần")=sigma^(k) tau^k
  $

  *Cách 2* :

  Ta chứng minh bằng quy nạp theo $k$.

Với $k=1$, hiển nhiên
$
(sigma tau)^1 = sigma tau = sigma^1 tau^1.
$

Giả sử với $k in NN$ ta có
$
(sigma tau)^k = sigma^k tau^k.
$

Khi đó
$
(sigma tau)^(k+1)
= (sigma tau)^k sigma tau
= sigma^k tau^k sigma tau.
$

Vì $sigma tau = tau sigma$ nên $tau^k sigma = sigma tau^k$. Do đó

$
(sigma tau)^(k+1)
= sigma^k sigma tau^k tau
= sigma^(k+1) tau^(k+1).
$

Vậy theo nguyên lý quy nạp,
$
(sigma tau)^k = sigma^k tau^k,
quad forall k in NN.
$
]
#baitoan[
Cho một ví dụ chứng tỏ rằng lũy thừa của một chu trình không nhất thiết là một chu
trình.
]
#loigiai[
  
  Trong nhóm hoán vị $S_4$, xét chu trình $sigma =mat(1,2,3,4)$, ta có $sigma^2=mat(1,3)mat(2,4)$ không là chu trình.
]
#baitoan[
   Xét nhóm hoán vị $S_n$ và $sigma$ là một k-chu trình. Chứng minh rằng với $l in NN$, $sigma^ l$
là
k-chu trình khi và chỉ khi $(k, l) = 1$.
]
#loigiai[
  
  *(<=)* Giả sử $(k,l)=1$, khi đó $exists a,b in ZZ$ sao cho $k a+l b=1$. Khi đó
  $
  sigma=sigma^(k a + l b)=sigma^(k a) sigma^(l b)=sigma^(l b) quad (1)
  $
  Vì $sigma $ là một k-chu trình , nên nếu $sigma^(l)$ không là k-chu trình thì $sigma^(l)$ phải có dạng tích của các chu trình có chiều dài nhỏ hơn $k$, từ đó $sigma^(l b)$ cũng có dạng giống vậy, mâu thuẫn với $(1)$.

  *(=>)* Giả sử $sigma^(l)$ là k-chu trình, khi đó 
  $
  o r d(sigma^(l))=(o r d (sigma))/gcd(k,l) <=> k=k/gcd(k,l) => gcd(k,l) = 1
  $
]
#pagebreak()
#baitoan[
Chứng minh các khẳng định sau:

*a)* $H = {mat(x, y; 2y, x) | x, y in QQ}$ là một nhóm con của nhóm $(M(2, QQ), +)$.

*b)* $H = {mat(x, y; 2y, x) | x, y in QQ; x^2 + y^2 > 0}$ là một nhóm con của nhóm $(G L(2, QQ), dot)$.



*c)* $U_n = {z in CC | z^n = 1}$ với $n in NN$; $U = {z in CC | exists k in NN^*, z^k = 1}$ và $T = {z in CC | |z| = 1}$ là các nhóm con của nhóm $(CC^*, dot)$.
]
#loigiai[
  
  *a)* 
  
  -*(i)* Có $H subset M(2,QQ)$, do $M(2,QQ)={mat(a,b;c,d)|a,b,c,d in QQ}$.

  -*(ii)* Có $0 in H$

  -*(iii)* Lấy tùy ý $A=mat(a_1,a_2;2 a_2,a_1) in H$ và $B=mat(b_1 , b_2; 2b_2,b_1) in H$, khi đó $A-B=mat(a_1-b_1, a_2-b_2;2(a_2-b_2),a_1-b_1) in H$.

  Từ (i),(ii),(iii) suy ra $H<=M((2,QQ),+)$.

  *b)*

  -*(i)* Có $H subset (G L(2,QQ))$. Do $mat( x , y ; 2 y , x ,delim:"|")=x^2-2y^2 !=0$.

  -*(ii)* Có $I_2 in H$.

  -*(iii)*  Với mọi $A = mat(x, y; 2y, x), B = mat(z, t; 2t, z) in H$, ta có
  $
  A B = mat(
    x z + 2 y t, x t + y z;
    2(x t + y z), x z + 2 y t
  ).
  $
  Vì $A, B in G L(2, QQ)$ nên $A B in G L(2, QQ)$, suy ra $A B != O$. Mặt khác, $x z + 2 y t, x t + y z in QQ$, do đó $A B in H$.
  $A = mat(x, y; 2y, x) in H$, ta có
  $
  A^(-1) = 1/(x^2 - 2y^2) mat(x, -y; -2y, x)
  = mat(
    x/(x^2 - 2y^2), -y/(x^2 - 2y^2);
    -2y/(x^2 - 2y^2), x/(x^2 - 2y^2)
  ).
  $
  Vì $x^2 - 2y^2 != 0$ và $x^2 + y^2 > 0$, suy ra
  $
  (x/(x^2 - 2y^2))^2 + (-y/(x^2 - 2y^2))^2
  = (x^2 + y^2)/(x^2 - 2y^2)^2 > 0.
  $
  Do đó $A^(-1) in H$.

  Từ (i),(ii),(iii) suy ra $H<=(G L(2,QQ),.)$

  *c)*

  Xét $U = {z in CC | exists k in NN^*, z^k = 1}$, khi đó

  *(i)* $U subset C^* "do "forall x in U,x !=0 $.

  *(ii)* Có $1 in U$ do $1 in C^*,1^2=1$.

  *(iii)* Lấy tùy ý $x in U$, khi đó có $k in NN^*$ sao cho $x^k=1=>(x^(-1))^k=1 => x^(-1)in U$, hơn nữa lấy $y,z in U$ thì có $m,n in NN^*$ sao cho $y^m=1,z^n=1$, suy ra $(y z)^(m n)=y^(m)^n z^(n)^m=1$, do đó $y z in U$.

  Từ (i),(ii),(iii) suy ra $U<=(C^*,.)$. Tương tự với $U_n,T$.
]
#baitoan[
*a)* Chứng minh rằng $H$ là một nhóm con của nhóm $(ZZ, +)$ khi và chỉ khi $H$ có dạng $n ZZ$ với $n in NN$.

*b)* Cho $m, n in NN$. Chứng minh rằng
$
m ZZ inter n ZZ = [m, n] ZZ
quad "và" quad
m ZZ + n ZZ = (m, n) ZZ.
$
]

#loigiai[

  *a)* 
  
  ($=>$) Giả sử $H$ là một nhóm con của $(ZZ, +)$. Nếu $H = {0}$ thì $H = 0 ZZ$. Nếu $H != {0}$, tồn tại $k in H$ với $k != 0$. Vì $H$ là nhóm con nên $-k in H$, do đó tồn tại số nguyên dương thuộc $H$. Theo nguyên lý thứ tự tốt, tồn tại $n$ là số nguyên dương nhỏ nhất thuộc $H$.

Vì $n in H$ và $H$ là nhóm con nên $n ZZ subset.eq H$. Ngược lại, với mọi $x in H$, theo phép chia Euclid, tồn tại $q, r in ZZ$ sao cho
$
x = q n + r, quad 0 <= r < n.
$
Do $x, n in H$ nên $r = x - q n in H$. Mà $n$ là số nguyên dương nhỏ nhất thuộc $H$ nên $r = 0$, suy ra $x = q n in n ZZ$. Do đó $H subset.eq n ZZ$. Vậy $H = n ZZ$.

*($<=$)* Giả sử $H = n ZZ$ với $n in NN$. Ta có $0 = 0n in H$ nên $H != emptyset$. Với mọi $x, y in H$, tồn tại $p, q in ZZ$ sao cho $x = p n$ và $y = q n$. Khi đó
$
x - y = p n - q n = (p - q)n in n ZZ = H.
$
Vậy $H$ là một nhóm con của $(ZZ, +)$.

*b)*

(i) Nhận xét, với các số nguyên $k,l$, ta có
$
k ZZ subset l ZZ <=> l divides k
$
Do đó, với $k in m ZZ inter n ZZ$ , thì ta có
$
cases(k in m ZZ,k in n ZZ) <=> cases( m divides k,n divides k) <=> cases([m,n] divides k) <=> k in [m,n] ZZ
$
Theo nhận xét trên, suy ra $
m ZZ subset(m,n) ZZ quad "và" quad n ZZ subset(m,n) ZZ
$
Do đó, $m ZZ + n ZZ subset (m,n) ZZ$.

Đặt $d=(m,n)$ khi đó $ exists a,b in ZZ$ sao cho $m a+ n b=d$, khi đó
$
(m,n) ZZ=d ZZ=(m a+ n b) ZZ subset m a ZZ+ n b ZZ subset m ZZ + n ZZ.
$
Do đó, $m ZZ+n ZZ =(m,n) ZZ$.
]

#baitoan[
Cho $(G, dot)$ là một nhóm và $H$ là một nhóm con của $G$. Chứng minh rằng với $x in G$, các khẳng định sau là tương đương:

*a)* $x H$ là nhóm con của $G$.

*b)* $H x$ là nhóm con của $G$.

*c)* $x in H$.
]
#loigiai[
  
  *(a => c)* Giả sử $x H$ là nhóm con của $G$, ta chứng minh $x in H $. Vì $x H <= G$, nên có $
  e in x H => exists y in H : e= x y => x=y^(-1) in H quad ("do H là nhóm con của G").
  $
  *(c => a)* Giả sử $x in H $, ta chứng minh $x H$ là nhóm con của $G$, vì $H <= G$ , nên ta chứng minh $x H=H$.
  Thật vậy, lấy $z in x H$, khi đó $z= x y$, với $y in H$ , do $x in H$ và $H<=G$ nên $x y in H$, suy ra $z in H$.Do đó, $x H subset H$. Hơn nữa, lấy $z in H$, khi đó
  $
  z=x x^(-1) z=x(x^(-1) z) in x H quad "(do" x^(-1) z in H).
  $
  Suy ra, $H subset x H$, do đó $x H= H$ , mà $H <= G$, suy ra $x H <= G$.
  Chứng minh tương tự, ta có $b<=>c$.
  
]
#baitoan[
Cho $(G, dot)$ là một nhóm và $H$ là một nhóm con của $G$. Chứng minh rằng với mỗi $x in G$, tập hợp $x^(-1) H x$ cũng là nhóm con của $G$ (Ta gọi đây là các _nhóm con liên hợp_ với $H$).
]
#loigiai[
  Với mỗi $x in G$, đặt $H^(x)=x^(-1) H x$, ta chứng minh $ H^(x)<=G$. Thật vậy, với $e  in H$, do $H<=G$, nên ta có
  $
  e=x^(-1) e x in H^(x) quad (1)
  $
  Lấy $a,b in H^(x)$, khi đó $exists y,z in H$ sao cho $ a= x^(-1) y x, b=x^(-1 ) z x $ khi đó $ a b =x^(-1)y x x^(-1) z x=x^(-1)y z x in H^(x) $ Hơn nữa, $a^(-1)=x^(-1) y^(-1) x in H^(x)$, do $y^(-1) in H$.
  Do đó, $H^(x) <= G$.
]

#baitoan[
Cho nhóm $(G, dot)$ và $a in G$. Ta định nghĩa

*1)* _Tâm hóa tử_ của $a$ trong $G$ là tập hợp
$
C(a) = {x in G | a x = x a}.
$

*2)* _Tâm_ của $G$ là tập hợp
$
C(G) = {x in G | x y = y x, forall y in G}.
$

Chứng minh rằng:

*a)* $C(G) <= C(a) <= G$;

*b)* $C(G) = inter.big_(b in G) C(b)$;

*c)* $G$ giao hoán $<=> C(G) = G$.

*d)* Mọi nhóm con của $C(G)$ đều là nhóm con chuẩn tắc của $G$.

*e)* Tìm tâm của nhóm tuyến tính tổng quát $op("GL")(n, RR)$.
]
#loigiai[

  *a)* Lấy $z in C(G)$, khi đó $ z y = y z , forall y in G$, chọn $y= a$ thì $z in C(a)$, do đó $C(G) subset C(a)$. Do đó, ta chỉ cần chứng minh $C(a) <= G$.Thật vậy, có $ a e = e a = a => e  in C(a) $.
  Lấy $x,y in C(a)$ khi đó $a x = x a <=> x= a^(-1)x a, y=a^(-1)y a$, suy ra 
  $
  x y = a^(-1)x a a^(-1)y a=a^(-1)(x y) a in C(a)
  $
  Hơn nữa, $x^(-1)=a^(-1) x^(-1) a <=> a x^(-1)=x^(-1) a => x^(-1) in C(a)$.Do đó, $C(a)<=G$, suy ra $C(G)<=C(a)<=G$.

  *(b)* Ta chỉ cần chứng minh $
  inter_(b in G)
   C(b) subset C(G)  $ Thật vậy, lấy $z in inter_(b in G) C(b)$, khi đó $b z = z b, forall b in G$ suy ra $z in C(G)$, do đó $C(G)= inter_(b in G) C(b)$.

   *c)* Cho $H$ là một nhóm con của $C(G)$. Khi đó $H$ cũng là một nhóm con của $G$. Hơn nữa, do mọi phần tử của $H$ giao hoán với mọi phần tử của $G$ nên $forall x in G, x H = H x$. Điều này chứng tỏ $H$ là nhóm con chuẩn tắc của $G$.

   *d)* Cho $H$ là một nhóm con của $C(G)$. Khi đó $H$ cũng là một nhóm con của $G$. Hơn nữa, do mọi phần tử của $H$ giao hoán với mọi phần tử của $G$ nên với mọi $x in G$ và $h in H$, ta có
$
x h x^(-1) = h x x^(-1) = h in H.
$
Suy ra $x H x^(-1) subset.eq H$. Thay $x$ bởi $x^(-1)$, ta được $x^(-1) H x subset.eq H$, hay $H subset.eq x H x^(-1)$. Do đó $x H x^(-1) = H$ với mọi $x in G$. Vậy $H$ là nhóm con chuẩn tắc của $G$.

*e)* Ta có $op("GL")(n, RR)$ là nhóm các ma trận vuông khả nghịch cấp $n$ trên $RR$. Ta chứng minh rằng
$
C(op("GL")(n, RR)) = {lambda I_n | lambda in RR, lambda != 0}.
$

Trước hết, với mọi $lambda in RR$ và $lambda != 0$, ta có $lambda I_n in op("GL")(n, RR)$. Hơn nữa, với mọi $B in op("GL")(n, RR)$,
$
(lambda I_n) B = lambda B = B (lambda I_n).
$
Suy ra
$
{lambda I_n | lambda in RR, lambda != 0} subset.eq C(op("GL")(n, RR)).
$

Ngược lại, giả sử $A = (a_(i j)) in C(op("GL")(n, RR))$. Khi đó $A$ giao hoán với mọi ma trận khả nghịch cấp $n$.

Xét ma trận đường chéo $D = op("diag")(1, 2, dots, n)$. Vì $D$ khả nghịch nên $A D = D A$. So sánh các phần tử ở vị trí $(i,j)$, ta có
$
j a_(i j) = i a_(i j)
=> (i-j) a_(i j) = 0.
$
Với $i != j$, suy ra $a_(i j) = 0$. Do đó $A$ là ma trận đường chéo, tức là
$
A = op("diag")(lambda_1, lambda_2, dots, lambda_n).
$

Với $i != j$, gọi $E_(i j)$ là ma trận có phần tử tại vị trí $(i,j)$ bằng $1$ và các phần tử còn lại bằng $0$. Xét $B = I_n + E_(i j)$. Vì $E_(i j)^2 = 0$ nên $B^(-1) = I_n - E_(i j)$, suy ra $B$ khả nghịch.

Do $A$ thuộc tâm nên
$
A B = B A
=> A E_(i j) = E_(i j) A
=> lambda_i E_(i j) = lambda_j E_(i j)
=> lambda_i = lambda_j.
$

Vì $i,j$ tùy ý với $i != j$, suy ra $lambda_1 = lambda_2 = dots = lambda_n = lambda$. Do đó $A = lambda I_n$. Mặt khác, $A$ khả nghịch nên $lambda != 0$. Trường hợp $n=1$ cũng hiển nhiên thỏa mãn kết luận này.

Vậy
$
C(op("GL")(n, RR)) = {lambda I_n | lambda in RR, lambda != 0}.
$
]

#baitoan[
Cho $H, K$ là các nhóm con của nhóm $G$. Chứng minh rằng $H union K$ là nhóm con của $G$ khi và chỉ khi $H subset K$ hay $K subset H$.
]

#loigiai[
Chiều đảo là hiển nhiên. Ta chứng minh chiều thuận. Thật vậy, giả sử $H union K <= G$ và $H subset.not K$. Khi đó tồn tại $h in H without K$. Với mọi $k in K$, vì $h, k$ đều thuộc $H union K$ nên theo tính chất của nhóm con ta có $h k in H union K$, nghĩa là $h k in H$ hay $h k in K$. Đặt $x = h k$. Nếu $x in K$ thì $h = x k^(-1) in K$, mâu thuẫn. Vậy $x in H$, do đó $k = h^(-1) x in H$. Điều này chứng tỏ $K subset H$.
]

#baitoan[
  Cho nhóm $(G, dot)$. Với $A, B subset G$, ta đặt
  $
    A B = {a b | a in A, b in B};
    quad
    A^(-1) = {a^(-1) | a in A}.
  $
  Chứng minh rằng với $A, B, C subset G$:

  *a)* $(A B) C = A (B C)$;

  *b)* $(A^(-1))^(-1) = A$;

  *c)* $(A B)^(-1) = B^(-1) A^(-1)$;

  *d)* Với $A != emptyset$, các khẳng định sau tương đương:

  #h(1em) i) $A$ là nhóm con của $G$;

  #h(1em) ii) $A A = A$ và $A^(-1) = A$;

  #h(1em) iii) $A^(-1) A = A$.

  *e)* Nếu $A, B$ là các nhóm con của $G$ thì $A B$ là nhóm con của $G$ khi và chỉ khi $A B = B A$; hơn nữa, khi đó
  $
    A B = A or B,
  $
  trong đó $A or B = chevron.l A union B chevron.r$.
]

#loigiai[
  *a)* Ta chứng minh $(A B) C = A (B C)$ bằng cách chứng minh hai bao hàm.

  Trước hết, lấy $x in (A B) C$ tùy ý. Theo định nghĩa tích hai tập hợp, tồn tại $u in A B$ và $c in C$ sao cho $x = u c$. Vì $u in A B$ nên tồn tại $a in A$, $b in B$ sao cho $u = a b$. Do đó
  $
    x = (a b)c = a(b c) in A(B C).
  $
  Suy ra $(A B) C subset.eq A(B C)$.

  Ngược lại, lấy $x in A(B C)$ tùy ý. Khi đó tồn tại $a in A$ và $v in B C$ sao cho $x = a v$. Vì $v in B C$ nên tồn tại $b in B$, $c in C$ sao cho $v = b c$. Do đó
  $
    x = a(b c) = (a b)c in (A B) C.
  $
  Suy ra $A(B C) subset.eq (A B) C$.

  Từ hai bao hàm trên, ta kết luận
  $
    (A B) C = A(B C).
  $

  *b)* Theo định nghĩa tập nghịch đảo, ta có
  $
    (A^(-1))^(-1)
    &= {x^(-1) | x in A^(-1)} \
    &= {(a^(-1))^(-1) | a in A} \
    &= {a | a in A} = A.
  $
  Vậy $(A^(-1))^(-1) = A$.

  *c)* Ta có
  $
    (A B)^(-1)
    &= {(a b)^(-1) | a in A, b in B} \
    &= {b^(-1) a^(-1) | a in A, b in B} \
    &= B^(-1) A^(-1).
  $
  Trong đó, ta đã sử dụng tính chất $(a b)^(-1) = b^(-1) a^(-1)$ với mọi $a, b in G$.

  *d)* Với $A != emptyset$, ta chứng minh các khẳng định tương đương theo sơ đồ
  $
    "i)" => "ii)" => "iii)" => "i)".
  $

  *Chứng minh (i) suy ra (ii).* Giả sử $A$ là nhóm con của $G$. Khi đó $A$ đóng đối với phép toán của $G$, nên với mọi $a, b in A$ ta có $a b in A$. Suy ra $A A subset.eq A$.

  Mặt khác, vì $e in A$ nên với mọi $a in A$, ta có $a = a e in A A$. Suy ra $A subset.eq A A$. Do đó $A A = A$.

  Vì $A$ là nhóm con nên với mọi $a in A$ ta có $a^(-1) in A$, suy ra $A^(-1) subset.eq A$. Ngược lại, với mọi $a in A$, do $a^(-1) in A$ nên $a = (a^(-1))^(-1) in A^(-1)$. Suy ra $A subset.eq A^(-1)$.

  Vậy $A A = A$ và $A^(-1) = A$.

  *Chứng minh (ii) suy ra (iii).* Giả sử $A A = A$ và $A^(-1) = A$. Khi đó
  $
    A^(-1) A = A A = A.
  $
  Vậy (iii) được chứng minh.

  *Chứng minh (iii) suy ra (i).* Giả sử $A^(-1) A = A$ và $A != emptyset$. Ta chứng minh $A$ là nhóm con của $G$.

  Vì $A != emptyset$ nên tồn tại $a in A$. Khi đó $a^(-1) a in A^(-1) A = A$, suy ra $e in A$.

  Với mọi $x in A$, vì $e in A$ nên
  $
    x^(-1) = x^(-1) e in A^(-1) A = A.
  $
  Do đó $A$ đóng đối với phép lấy nghịch đảo.

  Tiếp theo, với mọi $x, y in A$, vì $x^(-1) in A$ nên
  $
    x y = (x^(-1))^(-1) y in A^(-1) A = A.
  $
  Do đó $A$ đóng đối với phép toán của $G$.

  Như vậy, $A$ khác rỗng, chứa phần tử đơn vị, đóng đối với phép toán và phép lấy nghịch đảo. Suy ra $A$ là nhóm con của $G$.

  Vậy ba khẳng định (i), (ii), (iii) tương đương.

  *e)* Giả sử $A, B$ là các nhóm con của $G$. Ta chứng minh
  $
    A B <= G <=> A B = B A.
  $

  *Chiều thuận.* Giả sử $A B$ là nhóm con của $G$. Khi đó $(A B)^(-1) = A B$. Mặt khác, theo câu c), ta có
  $
    (A B)^(-1)
    &= B^(-1) A^(-1) \
    &= B A,
  $
  vì $A^(-1) = A$ và $B^(-1) = B$. Do đó $A B = B A$.

  *Chiều đảo.* Giả sử $A B = B A$. Ta chứng minh $A B$ là nhóm con của $G$.

  Vì $A, B$ là các nhóm con của $G$ nên $e in A$ và $e in B$, suy ra $e = e e in A B$. Do đó $A B != emptyset$.

  Theo câu c), ta có
  $
    (A B)^(-1) = B^(-1) A^(-1) = B A.
  $
  Từ giả thiết $B A = A B$, suy ra $(A B)^(-1) = A B$.

  Mặt khác, sử dụng tính kết hợp của tích các tập hợp và giả thiết $A B = B A$, ta có
  $
    (A B)(A B)
    &= A(B A)B \
    &= A(A B)B \
    &= (A A)(B B) \
    &= A B,
  $
  vì $A A = A$ và $B B = B$.

  Như vậy, $A B != emptyset$, $(A B)^(-1) = A B$ và $(A B)(A B) = A B$. Theo câu d), suy ra $A B$ là nhóm con của $G$.

  Vậy
  $
    A B <= G <=> A B = B A.
  $

  Cuối cùng, ta chứng minh rằng khi $A B = B A$ thì
  $
    A B = A or B = chevron.l A union B chevron.r.
  $

  Vì $e in A union B$ nên với mọi $a in A$ và $b in B$, ta có
  $
    a = a e in A B,
    quad
    b = e b in A B.
  $
  Suy ra $A union B subset.eq A B$. Mà $A B$ là nhóm con của $G$, nên theo định nghĩa nhóm con sinh bởi một tập hợp, ta có
  $
    chevron.l A union B chevron.r subset.eq A B.
  $

  Ngược lại, lấy $x in A B$ tùy ý. Khi đó tồn tại $a in A$, $b in B$ sao cho $x = a b$. Vì
  $
    a, b in A union B subset.eq chevron.l A union B chevron.r
  $
  và $chevron.l A union B chevron.r$ là nhóm con của $G$, nên
  $
    x = a b in chevron.l A union B chevron.r.
  $
  Suy ra $A B subset.eq chevron.l A union B chevron.r$.

  Từ hai bao hàm trên, ta kết luận
  $
    A B = chevron.l A union B chevron.r = A or B.
  $
]
#baitoan[
  Cho $(G, dot)$ là một nhóm Abel và $H$ là một nhóm con của $G$. Với mỗi $n in NN$ ta đặt
  $
    H_n = {x in G | x^n in H}.
  $
  Chứng minh rằng với $m, n in NN$ ta có

  *a)* $H_n$ là nhóm con của $G$, và $H_n$ chứa $H$.

  *b)* $H_m inter H_n = H_d$, trong đó $d = (m, n)$. Suy ra điều kiện để $H_m inter H_n = H$.
]
#loigiai[

  *a)* Với mỗi $n in NN$, xét $H_n={x in G | x^n in H}$ Có $e in H$, do $e^n=e $. Hơn nữa $forall x,y in H_n$, khi đó $x^n in H$ và $y^n in H$, do $H<=G$, nên $x^(n)^(-1) in H$, do đó $x^(-1)y = x^(n)^(-1) y^n in H $, vậy $H<=G$.

  *b)* Lấy tùy ý $x in H_m inter H_n$, khi đó 
  $
  cases(x  in H_m, x in H_n) <=> cases(x^m in H,x^n in H) quad (*)
  $
  Do $d=(m,n)$, do đó $d | m, d|n$, suy ra $exists a,b in ZZ $ sao cho $a d = m, b d=n quad (1)$ , do đó thay $(1)$ vào $(*)$, ta được $x^(a d)=(x^(a))^d in H$ và $(x^(b))^d in H $. Do đó $x in H_d$, hơn nữa lấy tùy ý $y in H_d$, khi đó $y^d in H_d$, với $d=(m,n)$ theo định lý Bézout thì $exists a,b in ZZ : d = m a + n b$.Khi đó $y^d=y^(m a + n b)=y^(m a). y^(n b)=(y^a)^m (y^b)^n in H$ , do đó $H_d subset H_m inter H_d $. Suy ra $H_m inter H_n = H_d$.

  Khi đó, $ H_m inter H_n = H  <=>H_d=H $.
]
#pagebreak()
#baitoan[
  Cho $(G, dot)$ là một nhóm Abel và $H$ là một nhóm con của $G$. Đặt
  $
    K = {x in G | exists n in NN^(*), x^n in H}.
  $
  Chứng minh rằng

  *a)* $K$ là nhóm con chuẩn tắc của $G$, và $K$ chứa $H$.

  *b)* Trong nhóm thương $G\/K$ không có phần tử nào có cấp hữu hạn lớn hơn $1$.
]
#loigiai[

  *a)* Vì $(G,.)$ là nhóm Abel, nên ta chỉ cần chứng minh $K<=G$. Thật vậy, có $e in K $ do có $1 in NN^* : e^1=e in H $ vì $H$ là nhóm con nên $e in H$. Hơn nữa, lấy tùy ý $x,y in K$, khi đó có $ a,b in NN^* : x^a in H, y^b in H $ Do $H<= G$, nên $(x^(a))^(-1) in H$ , xét $(x^(-1) y)^(a b)=((x^a)^(-b) (y^(b))^a in H$, do đó $x^(-1) y in K$.

  Hơn nữa, lấy $x in H $, do $H<=G$ , nên $x y in H, forall y in H$, chọn $y = x$, có $x^2 in H$, suy ra $exists n= 2 in NN^* : x^2 in H$. Do đó $x in K$, Vậy $H subset K$.

  *b)*
  Lấy tùy ý $x in G\/ K$, khi đó $x= a K$ với mỗi $a in G$, giả sử $|x|=m$, khi đó $x^m=K$. Hơn nữa $(a K)^m=(a K) (a K)...(a K)=a^m K=K$, suy ra $a^m in K$. Vì $a^m in K$, nên có $n in NN^*: a^(m n) in H$. Vì $m n in NN^*$, nên $a in K$, suy ra $a K=K$, hay $x= K$, do đó $|x|=1$.
]
#baitoan[
  Cho nhóm $(G, dot)$ và $H, K$ là hai nhóm con của $G$. Chứng minh rằng nếu $H$ và $K$ có chỉ số hữu hạn trong $G$ thì nhóm con $H inter K$ cũng có chỉ số hữu hạn trong $G$.
]
#loigiai[
   Giả sử $H$ và $K$ có chỉ số hữu hạn $G$, khi đó $|G:H|=m<infinity$ , $|G:K|=n <infinity$ và $H inter K <= G$. Xét $
   f: G\/(H inter K) -> G\/H times G \/K , x(H inter K) -> (x H,x K)
   $
   Ta chứng minh $f$ xác định tốt, khi đó với mỗi $x,y in G$, giả sử
   $
   x(H inter K)=y (H inter K)
   $
   Ta chứng minh $f(x(H inter K))=f(y(H inter K))$. Có $x(H inter K)= y( H inter K)$, khi đó $(x H,x K)=(y H ,y K)$. Thật vậy, có $x H=y H$, do $x(H inter K)=y( H inter K)$, tương tự ta được $x K= y K$, khi đó $f(x (H inter K)=f(y (H inter K))$.

   Ta chứng minh $f$ là đơn ánh khi đó $|G\/H||G\/K|=m . n <infinity$ thì $|G:H inter K| <= m n < infinity$. Thật vậy, lấy tùy ý $x (H inter K) , y (H inter K) in G\/(H inter K)$, giả sử $f(x(H inter K))=f(y(H inter K)).$ Khi đó $(x H, x K)=(y H,y K)$. Ta được
   $
  cases(x H= y H,x K= y K) quad (1)
   $
   Ta chứng minh $x (H inter K)= y(H inter K)$. Từ $(1)$, ta được $y^(-1) x in H$ và $y^(-1) x in K$, do đó $y^(-1) x in H inter K$. Lấy $z in x(H inter K)$, khi đó $z =x a$, với $a in H inter K$. Có $z=y y^(-1)x a=y (y^(-1 )x a)$ do $y^(-1) x in H inter K => (y^(-1) x a) in H inter K$, do $H inter K <= G$ do đó $z in y(H inter K)$. Vậy $x(H inter K) subset y(H inter K).$ Hơn nữa, có $z in y (H inter K)$, khi đó $z=y k$, với $k in H inter K$, ta có $z = x x^(-1) y k=x(x^(-1)y k)$. Do $x^(-1) y in H inter K$, nên $x^(-1)y k in H inter K$, suy ra $z in x( H inter K)$. Do đó $x(H inter K)= y(H inter K)$. Vậy $f$ là đơn ánh.
   
]
#baitoan[
  Cho nhóm $(G, .)$ hữu hạn và $H, K$ là hai nhóm con của $G$.
  Chứng minh rằng
  $ |H K| |H inter K| = |H| |K|. $
]

#baitoan[
  Chứng minh rằng trong nhóm hoán vị $S_n$, mọi $k$-chu trình đều có cấp $k$ và cấp của tích các chu trình rời nhau bằng bội chung nhỏ nhất của các cấp của các chu trình này.
]
#loigiai[
   Gọi $sigma=(sigma_1 sigma_2 ... sigma _n) in S_n$, giả sử $
   |sigma_1|&=k_1\
   |sigma_2|&=k_2\
   ...\
  |sigma_n|&=k_n.
  $
  Đặt $l=lcm(k_1, k_2,...k_n)$ , khi đó ta chứng minh $o r d(sigma)=l$. Thật vậy, ta có $sigma^l=sigma_1^l ... sigma_n^l$,với $i in {1,2,..n}$ ta đều có $k_i | l$, do đó $sigma_i^l=e,forall i in {1,2,...,n}$, suy ra $o r d(sigma) | l$. Đặt $t=o r d (sigma)$, khi đó xét $sigma^t=sigma_1^t ... sigma_n ^t$, khi đó các $sigma_i^t=e, forall i in {1,2,...,n}$, suy ra $l | t$. Hay $t=l$.
]

#baitoan[
  *a)* Hãy mô tả tất cả các phần tử có cấp $20$ trong $S_9$.

  *b)* Chứng minh rằng trong $S_9$ không tồn tại phần tử nào có cấp $18$.
]
#loigiai[

  *a)* Giả sử $sigma in S_9$, thỏa $o r d (sigma)=20$, khi đó , đặt $sigma=(sigma_1 sigma_2...sigma_r)$, và $o r d(sigma_1)=k_1,o r d(sigma_2)=k_2,...$ khi đó $lcm(k_1 k_2...k_r)=20$. Vì $20=2^2 5$, hơn nữa, do $k_1+k_2+...k_r<=9$, nên $k_1=4,k_2=5$. Suy ra
  $
  sigma=(a_1 a_2 a_3 a_4)(b_1 b_2 b_3 b_4 b_5) 
  $
  Trong đó $a_i , 1<=i<=4, a_i in {1,2,..,9}$ và $b_i, 1<=i<=5$, các $a_i$ và $b_i$ đôi một khác nhau.

  *b)* Giả sử có phần tử cấp $18$ trong $S_9$, gọi $sigma=(sigma_1...sigma_r)$ và $ o r d(sigma)=18$. Khi đó, tương tự ý trên , có $lcm(k_1...k_r)=18$ mà $18=2.3^2$, do đó có $k_i in {k_1,k_2,...k_r} : k_i=9$ vì $1<=k_i<=9$ , nên $sigma=sigma_k => |sigma|=9$, do trong phân tích của $sigma$, phải có một $9-$ chu trình. Mâu thuẫn, vậy không tồn tại $|sigma|=18$.
]

#baitoan[
  \* Giả sử $G$ là một nhóm con Abel có cấp $1111$ trong $S_999$. Chứng minh rằng tồn tại $i in brace.l 1, 2, dots, 999 brace.r$ sao cho $sigma(i) = i$, $forall sigma in G$.
]

#loigiai[
  Ta có
$
  |G| = 1111 = 11 dot 101,
$
trong đó $11$ và $101$ đều là các số nguyên tố.

Theo định lý Cauchy, tồn tại $a, b in G$ sao cho
$
  |a| = 11, quad |b| = 101.
$

Vì $G$ là nhóm Abel nên $a b = b a$. Mặt khác, $gcd(11, 101) = 1$, do đó
$
  |a b| = |a| dot |b| = 1111 = |G|.
$

Suy ra $G = chevron.l a b chevron.r$. Đặt $sigma = a b$, khi đó
$
  G = chevron.l sigma chevron.r,
  quad |sigma| = 1111.
$

Vì $sigma in S_999$, ta phân tích $sigma$ thành tích các chu trình rời nhau:
$
  sigma = sigma_1 sigma_2 dots sigma_r.
$

Theo định lý về cấp của hoán vị, ta có
$
  |sigma| = lcm(
    |sigma_1|, |sigma_2|, dots, |sigma_r|
  ) = 1111.
$

Do đó, với mọi $j in brace.l 1, dots, r brace.r$, độ dài của chu trình $sigma_j$ phải là ước của $1111$, tức là
$
  |sigma_j| in brace.l 1, 11, 101, 1111 brace.r.
$

Mặt khác, vì $sigma in S_999$ nên không thể tồn tại chu trình có độ dài $1111$. Suy ra
$
  |sigma_j| in brace.l 1, 11, 101 brace.r.
$

*Giả sử ngược lại* rằng $sigma$ không có điểm cố định. Khi đó, trong phân tích trên không tồn tại chu trình có độ dài $1$.

Gọi $u$ là số chu trình có độ dài $11$ và $v$ là số chu trình có độ dài $101$.

Vì các chu trình rời nhau phân hoạch tập $brace.l 1, 2, dots, 999 brace.r$, nên
$
  11u + 101v = 999,
  quad u, v in NN.
$

Suy ra
$
  101v <= 999
  <=> 0 <= v <= 9.
$

Mặt khác, lấy đồng dư modulo $11$, ta được
$
  101v equiv 999 quad ("mod" 11)
$

hay
$
  2v equiv 9 quad ("mod" 11).
$

Vì $2 dot 6 equiv 1 quad ("mod" 11)$, nên
$
  v equiv 54 equiv 10 quad ("mod" 11).
$

Điều này mâu thuẫn với $0 <= v <= 9$.

Vậy $sigma$ phải có ít nhất một điểm cố định, tức là tồn tại $i in brace.l 1, dots, 999 brace.r$ sao cho
$
  sigma(i) = i.
$

Vì $G = chevron.l sigma chevron.r$, nên với mọi $tau in G$, tồn tại $k in ZZ$ sao cho $tau = sigma^k$.

Do đó
$
  tau(i) = sigma^k(i) = i.
$

Vậy
$
  exists i in brace.l 1, dots, 999 brace.r,
  forall tau in G: tau(i) = i.
$

Điều phải chứng minh.
]
#baitoan[
  Tìm hai phần tử $a, b$ của một nhóm $G$ sao cho $a, b$ đều có cấp hữu hạn nhưng $a b$ lại có cấp vô hạn.
]
#loigiai[

  Xét nhóm $G=G L(2, RR)$. Chọn $a=mat(0,-1;1,0)$ và $b=mat(0,1;-1,-1)$. Khi đó, $|a|=4$ và $|b|=3$. Nhưng $|a b|=infinity$.
]
#baitoan[
  Cho nhóm $(G, .)$ và $a, b in G$. Chứng minh rằng

  *a)* Cấp của $a b$ bằng cấp của $b a$.

  *b)* Cấp của $a^(-1)$ bằng cấp của $a$.

  *c)* Giả sử $a b = b a$ và $a$ có cấp $r$, $b$ có cấp $s$, trong đó $r, s$ nguyên tố cùng nhau; khi đó $a b$ có cấp $r s$.

  *d)* Giả sử $a b = b a$ và $a$ có cấp $r$, $b$ có cấp $s$, trong đó $chevron.l a chevron.r inter chevron.l b chevron.r = brace.l e brace.r$; khi đó $a b$ có cấp $[r, s]$.
]
#loigiai[

  *a)* 
  
  Giả sử $|a b|=n$, khi đó có $
  (a b)^n =(a b)( a b)(a b)=a(b a)^(n-1) b=e <=>(b a)^(n-1) b a =e <=> (b a)^n=e
  $
  Do đó, $b a|= n$.

  *b)*
  Có $(a^n)=e <=> (a^(-1))^n=e$, nên $|a^(-1)|=|a|$.

  *c)* Giả sử $a b=b a$, khi đó xét $
  (a b)^(r s)=(a^ r)^(s) (b^s)^r quad "Do ab=ba"
  $
  Suy ra, $(a b)^(r s)=e$, đặt $k= o r d(a b)$, thì $k | r s$. Hơn nữa, xét $(a b)^ k=a^ k b^k=e => a^k=b^(-k) => (a^k)^(s)=(b^(-k))^s=e $, do đó $r | k s$ mà $gcd(r,s)=1$, nên $r | k$, tương tự ta có $s | k$, suy ra $r s | k$. Vậy , $|a b|=r s$.

  *d)* Đặt $m=[r,s]$ và $k=|a b|$. Khi đó $(a b)^k=a^k b^k=e quad (1) $, vì $(a b)^m =e$ , nên $k | m$. Ta chứng minh $m | k$. Thật vậy, từ $a^k b^k=e => a^k=b^(-k)$, trong đó $a^k in chevron.l a chevron.r $ và $b^(-k) in chevron.l b chevron.r$ , nên $a^k=e$ và $b^(-k)=e <=> a^k=e, b^k=e => k | r , k | s => m | k$. Vậy,$[r,s]=|a b|$.

  
]
#baitoan[
  Chứng minh rằng nếu $G$ là một nhóm có hơn một phần tử và chỉ có hai nhóm con là $brace.l e brace.r$ và $G$ thì $G$ phải là nhóm cyclic cấp nguyên tố.
]
#loigiai[
  Giả sử $G$ là nhóm có hơn một phần tử và chỉ có $2$ nhóm con là ${e}$ và $G$, ta chứng minh $G$ là nhóm cyclic cấp nguyên tố.

  Lấy $a != e in G$, xét nhóm con $H$ sinh bởi $a$. Khi đó $H=chevron.l a chevron.r$. Vì $a != e$, và $H$ chứa ít nhất $2$ phần tử $a,e$, do đó $H!={e}$ vì $G$ chỉ có $2$ nhóm con nên $H=G$. Ta chứng minh cấp của $G$ là số nguyên tố.

  Nếu $|G|$ vô hạn, thì $|G|$ phải có vô số nhóm con.

  Do đó, đặt $|G|=n < infinity$, ta chứng minh $n$ là số nguyên tố, giả sử $n$ không là số nguyên tố, khi đó có $k | n$, thì $chevron.l a^k chevron.r$ là một nhóm con của $G$ và khác ${e}$, do $1<o r d (x^k)=n/k<n$, mâu thuẫn với $G$ chỉ có $2$ nhóm con, do đó $n$ là số nguyên tố.
]
#baitoan[
  Chứng minh rằng điều kiện cần và đủ để nhóm $G$ chỉ có hữu hạn nhóm con là $G$ hữu hạn.
]
#loigiai[
  
  *=>)* Giả sử $G$ chỉ có hữu hạn nhóm con, khi đó ta chứng minh $G$ hữu hạn. Phản đảo : Giả sử $G$ vô hạn , ta chứng minh $G$ có vô hạn nhóm con.

  *TH1* : Mọi $x in G$ đều có cấp hữu hạn, xét $x_1 in G$, khi đó  $chevron.l x_1 chevron.r<=G G$ có hữu hạn phần tử nên $chevron.l x_1 chevron.r !=G$, xét $x_2 in G backslash{x_1}$, ta được $chevron.l x_2 chevron.r <=G$ có hữu hạn phần tử và $ chevron.l x_1 chevron.r union chevron.l x_2 chevron.r !=G $ Tiếp tục quá trình trên ta thu được vô hạn nhóm con của $G$.

  *TH2* : Có $x in G$ sao cho $x$ có cấp vô hạn, vì $x$ có cấp vô hạn nên $chevron.l x chevron.r ,chevron.l x^2 chevron.r ,...$ đôi một khác nhau, do đó $G$ có vô hạn nhóm con.

  *(<=)* Giả sử $G$ hữu hạn, chứng minh $G$ chỉ có hữu hạn nhóm con. Thật vậy, đặt $|G|=n<infinity$, khi đó $H$ là nhóm con của $G$ thì đặc biệt là tập con của $G$ mà số tập con có thể có của $G=2^n < infinity$, do đó $G$ có hữu hạn nhóm con.
]
#baitoan[
  Chứng minh:

  *a)* Mọi nhóm cyclic đều giao hoán.

  *b)* Mọi nhóm con của một nhóm cyclic cũng cyclic.

  *c)* Ảnh đồng cấu của một nhóm cyclic cũng cyclic.
]
#loigiai[
  Giả sử $(G,.)$ là nhóm cyclic. Đặt $G={a^k:k in ZZ}=chevron.l a chevron.r$.  
  
  *a)* Lấy tùy ý $x,y in G$. Ta chứng minh $x y = y x$. Vì $x,y in G$, nên $exists m,n in ZZ : x=a^m,y=a^n$. Có $x y=a^(m) a^n=a^(m+n)=a^n a^m= y x$.

  *b)* Xét $H<=G$.Nếu $H={e}$, thì $H=chevron.l e chevron.r$. Giả sử $H != {e}$, khi đó có $a in G$, sao cho $a^k in H$, do $H<=G$, nên $a^(-k) in H$. Do đó , tập $S={k in ZZ^+:a^k in H}!=emptyset$. Theo nguyên lý thứ tự tốt của $NN$, tìm được $n=min{S}$, khi đó $a^n in H$. Ta chứng minh $H= chevron.l a^n chevron.r$.

  Vì $a^n in H$, mà $H$ đóng với phép toán $.$ suy ra $chevron.l a^n chevron.r subset H$.

  Lấy tùy ý $y in H$, ta chứng minh $y in chevron.l a^n chevron.r$. Vì $y in H$, mà $H <=G$, nên có $m in ZZ$ sao cho  $y=a^m$, ta chứng minh $n | m$. Thực hiện phép chia Euclide m cho n ta được :

  $
  m=q n+ r, 0<=r < q
  $
  Khi đó, $r=m-q n$, suy ra $a^r=a^m (a^(-q))^n=a^m (a^(-n))^q in H$, mâu thuẫn với $n$ là chỉ số nhỏ nhất để $a^n in H$. Vậy $r=0$, hay $m=q n$, suy ra $y in chevron.l a_n chevron.r$. Vậy $H= chevron.l a^n chevron.r$. Do đó, mọi nhóm con của nhóm cylic đều là nhóm cyclic.

  *c)* Xét $f : G -> G'$ và đặt $f(G)={f(x): x in G}={f (a^n): n in ZZ}={(f(a)^n:n in ZZ)}=chevron.l f(a) chevron.r$.
]
#baitoan[
  Cho nhóm cyclic $G = chevron.l x chevron.r$ hữu hạn cấp $n$. Chứng minh rằng với $k, l in ZZ$ ta có

  *a)* Cấp của $x^k$ bằng $n / d$, trong đó $d = (n, k)$.

  *b)* $chevron.l x^k chevron.r = chevron.l x^l chevron.r$ khi và chỉ khi $(n, k) = (n, l)$.

  *c)* $G = chevron.l x^k chevron.r$ khi và chỉ khi $(n, k) = 1$. Từ đó suy ra số các phần tử sinh của $G$.

  *d)* Hãy mô tả tất cả các nhóm con của $G$.
]
#loigiai[
  Xét $G=chevron.l x chevron.r $ và $|G|=n$. Lấy $k,l in ZZ$.
  
 *a)*
 
 *Cách 1. Sử dụng ước chung lớn nhất.*

Đặt $d = gcd(n,k)$. Khi đó tồn tại $n_1, k_1 in ZZ$ sao cho

$ n = d n_1, quad k = d k_1, quad gcd(n_1,k_1) = 1. $

Với mọi $m in NN^*$, ta có

$
  (x^k)^m = e
  &<=> x^(k m) = e \
  &<=> n | k m \
  &<=> d n_1 | d k_1 m \
  &<=> n_1 | k_1 m \
  &<=> n_1 | m.
$

Trong đó, tương đương cuối cùng suy ra từ bổ đề Euclid vì $gcd(n_1,k_1) = 1$.

Như vậy, số nguyên dương nhỏ nhất $m$ thỏa mãn $(x^k)^m = e$ chính là $m = n_1$.

Do đó,

$ upright("ord")(x^k) = n_1 = n / gcd(n,k). $

*Cách 2. Sử dụng bội chung nhỏ nhất.*

Trước hết, xét $k != 0$. Đặt $upright("ord")(x^k) = m$.

Theo định nghĩa cấp của phần tử, $m$ là số nguyên dương nhỏ nhất sao cho

$
  (x^k)^m = e
  <=> x^(k m) = e
  <=> n | k m.
$

Do đó, $abs(k) m$ là bội chung dương nhỏ nhất của $n$ và $abs(k)$. Suy ra

$ abs(k) m = upright("lcm")(n, abs(k)). $

Mặt khác, ta có hệ thức

$ upright("lcm")(n, abs(k)) gcd(n,k) = n abs(k). $

Vì vậy,

$ abs(k) m gcd(n,k) = n abs(k). $

Do $k != 0$, suy ra

$ m = n / gcd(n,k). $

Nếu $k = 0$, ta có $x^0 = e$, nên

$ upright("ord")(x^0) = 1 = n / gcd(n,0). $

*b)* Có $
|chevron.l x^k chevron.r|=n/(gcd(n,k))
$ và $ |chevron.l x^l chevron.r|= n/(gcd(n,l)) $ Và $|chevron.l x^k chevron.r|=|chevron.l x^l chevron.r| <=> n/(gcd(n,k))=n/(gcd(n,l))<=> gcd(n,l)=gcd(n,l)$.

*c)*
]

#baitoan[
  Cho hai nhóm $G_1$ và $G_2$, trong đó mỗi nhóm có ít nhất hai phần tử. Chứng minh rằng nhóm $G_1 times G_2$ cyclic khi và chỉ khi $G_1$ và $G_2$ là các nhóm cyclic hữu hạn có cấp nguyên tố cùng nhau.
]
#loigiai[

  *(=>)* Giả sử $G_1 times G_2$ là nhóm cyclic. Khi đó, do có ít nhất $2$ phần tử với mỗi $G_1$ và $G_2$, nên ta chọn $a in G_1$ và $b in G_2$ sao cho $G_1 times G_2=chevron.l (a,b) chevron.r$. Ta chứng minh $G_1$ là nhóm cyclic. Thật vậy, với tùy ý $x in G_1$, ta luôn có $(x,e_2) in G_1 times G_2$ nên suy ra, có $k in ZZ$ sao cho $x=a^k$ và $b^k=e$. Nên $G_1=chevron.l a chevron.r$. Tương tự, ta có $G_2= chevron.l b chevron.r$. Ta chứng minh $G_1$ và $G_2$ hữu hạn, giả sử $G_1$ vô hạn, khi đó $a$ có cấp vô hạn, vì $|G_2| >=2$ nên xét $y in G_2 : y!=e_2$. Khi đó, $(e_1,y) =(a,b)^k=(a^k,b^k) => e_1=a^k , y=b^k => k=0$ vậy $y=e_2$ mâu thuẫn, do đó, $G_1$ có cấp hữu hạn, tương tự với $G_2$.

  Ta chứng minh $m=|G_1|$ và $n=|G_2|$ và $gcd(m,n)=1$. Thật vậy, ta chứng minh $m .n =lcm(m,n)$. Lấy $(x,y) in G_1 times G_2$, nếu $
  (a,b)^k=(e_1,e_2) => cases( m | k , n | k) => |(a,b)|=lcm(m,n)
  $
  Do đó, $gcd(m,n)= (m n) / (l c m (m,n))=1$.

  *(<=)* Giả sử $G_1 times G_2$ là nhóm cylic và có cấp hữu hạn, hơn nữa $gcd(|G_1|,|G_2|)=gcd(m,n)=1$. Nên suy ra,$|chevron.l (a,b) chevron.r|=lcm(m,n)= m n$ mà mặt khác $|G_1 times G_2|= m n$. Nên $G_1 times G_2 = chevron.l (a,b) chevron.r$. Vậy $G_1 times G_2$ là nhóm cyclic. 
]
#baitoan[
  Chỉ ra rằng quan hệ "chuẩn tắc" trên tập hợp các nhóm con không có tính bắc cầu.
  
]
#loigiai[
  Ta định nghĩa quan hệ "Chuẩn tắc" trên tập hợp các nhóm con như sau. Cho $(G,*)$ là một nhóm, đặt $H^*={ H : H <=G}$. Khi đó, ta chứng minh quan hệ $~$ trên $H^*$ không có quan hệ bắc cầu 
]

#baitoan[
  Cho $(G, .)$ là một nhóm và $H$ là một nhóm con của $G$. _Chuẩn hóa tử_ của $H$ trong $G$ là tập con của $G$ định bởi:
  $ N_G(H) = brace.l x in G | x H = H x brace.r. $
  Chứng minh rằng

  *a)* $N_G(H)$ là nhóm con của $G$.

  *b)* $H$ là nhóm con chuẩn tắc của $N_G(H)$.

  *c)* $H$ là nhóm con chuẩn tắc của $G$ khi và chỉ khi $N_G(H) = G$.

  *d)* $N_G(H)$ là nhóm con lớn nhất của $G$ nhận $H$ làm nhóm con chuẩn tắc.
] 
#loigiai[

  *a)* Lấy $x in G$, $H<=G$. đặt $N_(G(H))={x in G : x H = H x}$. Ta có $ e in G$ và $e=e H=H e$. Do đó, $e in N_(G(H)) => N_(G(H))!=emptyset$. Lấy tùy ý $y,z in N_(G(H))$, ta chứng minh $y z in N_(G(H))$. Khi đó, xét $x y (H)=x (y H)=x (H y)=(x H) y=H(x y)$. Suy ra, $x y in N_(G(H))$. Hơn nữa, có $x H= H x => x^(-1) H = H x^(-1) => x^(-1) in N_(G(H))$. Do đó, $N_(G(H))<= G$.

  *b)* Ta chứng minh $H$ là nhóm con chuẩn tắc của $N_(G(H))$. Thật vậy, lấy tùy ý $x in N_(G(H)) $, và $y in H$, ta chứng minh $x^-1 y x in H$. Vì $y in H => x^(-1) y x = x^(-1) ( y x)$. Do $x H = H x => exists y' in H : x y'=y x $, do đó, $x^(-1) y  x=x^-1 x y'= y' in H$. Do đó $H chevron.l N_(G_(H))$. 

  *c)* *(=>)* Giả sử $H chevron.l G$. Khi đó, cần chứng minh $N_(G(H))=G$. Vì $H chevron.l G$, nên với tùy ý $x in G$, ta đều có $x H= H x => N_(G(H))=G$.

  *(<=)* Giả sử $N_(G(H))=G$, khi đó hiển nhiên $H chevron.l G$.

  *d)* Giả sử $ K<=G$ và $H chevron.l K$. Ta chứng minh $K subset $. Khi đó , $forall x in K: x H= y H$, do đó, $K subset N_(G(H))$. Vậy ta có điều phải chứng minh.
]

#baitoan[
  Cho $H, K$ là hai nhóm con của nhóm $(G, .)$. Chứng minh rằng:

  *a)* Nếu $H$ chuẩn tắc trong $G$ thì $H K$ là nhóm con của $G$.

  *b)* Nếu $H, K$ đều chuẩn tắc trong $G$ thì $H K$ là nhóm con chuẩn tắc của $G$.
]
#loigiai[
 
 *a)* Giả sử $H chevron.l G$, cần chứng minh $H K <=G$. Đặt $H K={h k : h in H, k in K}$. Ta có $e=e_H e _G in H K$, do đó $H K != emptyset$. Lấy tùy ý $x,y in H K$, ta chứng minh $x^(-1) y in H K$. Vì $x,y in H K$ nên $exists h_x,h_y in H, k_x,k_y in K : x=h_x k_x, y=h_y k_y .$ Suy ra $ y x^(-1)=h_y k_y k_x^(-1) h_x^(-1) $ Ta có $h_x in H => h_x^(-1) in H => k_x^(-1) h_x^(-1) in k_x^(-1) H$ mà $H$ chuẩn tắc nên $k_x^(-1) h_x^(-1) in H k_x^(-1)$, do đó có $h_3: k_x^(-1)h_x^(-1)=h_3 k_x^(-1)$, suy ra $y_x^(-1)=h_y k_y  h_3 k_x^(-1)$, tương tự ta có $h_4 in H$, sao cho $k_y h_3= h_4 k _y$, do đó $y x^(-1)=h_y h_4 k_y k_x^(-1)$, vì $h_y h_ 4 in H$, đặt $h'=h_y h_4 in H,k'=k_y k_x^(-1) in K$. Khi đó $y x^(-1)= h' k' in H K$. Vậy $H K <= G$.

 *b)*
  Giả sử $H,K$ chuẩn tắc trong $G$. Ta chứng minh $H K$ chuẩn tắc trong $G$. Từ $a)$, ta suy ra $H K <= G$, lấy tùy ý $g in G$, ta chứng minh $g H K= H K g$. Lấy $x in g H K$, khi đó $x = g h_x k_x$, vì $H$ chuẩn tắc nên $g H=H g$, do đó có $h_1 in H: g h_x=h_1 g $ suy ra $x= h_1 g k_x$, tương tự vì $g K=K g$, nên có $k_1 in K : g k_x=k_1 g$, do đó $x=h_1 k_1 g in H K g$, suy ra $g H K subset H K g$.

  Lấy $x in H K g$, khi đó $x = h_x k_x g$, vì $K g = g K$, nên có $k_1 in K : k_x g=g k_1$, suy ra $x=h_x g k_1$, tương tự ta có $h_1 in H $ sao cho $h_x g= g h_1$, do đó $x=g h_1 k_1 in g H K$. Vậy với tùy ý $g in G$, ta đều có $g H K=H K g$ nên $H K triangle.l G$.
]
#baitoan[
  Cho $H, K$ là hai nhóm con chuẩn tắc của nhóm $(G, .)$ thỏa $H inter K = brace.l e brace.r$. Chứng minh rằng $x y = y x$ với mọi $x in H$, $y in K$.
]
#loigiai[
  Xét $g=x y x^(-1) y^(-1)$, ta chứng minh $ g in H inter K $. Thật vậy, với mỗi $y in G$, đặc biệt $y in K$, ta đều có $y^(-1) x y in H$, với $x in H$ và do $H triangle.l G$, nên $y^(-1) x^(-1) y in H$, do đó $g in H$, với mỗi $x in G$, đặc biệt $x in H$, ta đều có $x^(-1) y x in K$, do đó $g in K$, do $y^(-1) in K$. Suy ra $g in H inter K$, mà $H inter K={e}$, do đó $g= e$, hay $x y = y x$.
]

#baitoan[
  Cho nhóm $(G, .)$ và $S subset.eq G$ thỏa $x^(-1) S x subset.eq chevron.l S chevron.r$ với mọi $x in G$. Chứng minh $chevron.l S chevron.r$ chuẩn tắc trong $G$.
]
#loigiai[
  Lấy tùy ý $x in G,y in chevron.l S chevron.r$.Với $S={s : s in G}$.
  
  Đặt $chevron.l S chevron.r={s^k:k in ZZ}. $ Ta chứng minh $x^(-1) y x in chevron.l S chevron.r$. Vì $y in chevron.l S chevron.r $, nên có $k in ZZ: y=s^k$. Khi đó $y in S$, mà $x^(-1) S x subset chevron.l S chevron.r$, nên $x^(-1) y x in chevron.l S chevron.r$.
  Vậy $chevron.l S chevron.r chevron.l G$.
]


#baitoan[
  Cho $G$ là một nhóm hữu hạn và $H$ là một nhóm con của $G$ có chỉ số $[G : H] = 2$. Chứng minh $H$ là một nhóm con chuẩn tắc của $G$. Hãy tổng quát hóa kết quả trên.
]
#loigiai[
Ta chứng minh $H$ là nhóm con chuẩn tắc của $G$, tức là
$
  forall g in G, quad g H g^(-1) = H.
$

Lấy $g in G$ tùy ý. Xét hai trường hợp:

*Trường hợp 1:* $g in H$.

Vì $H$ là nhóm con của $G$, nên
$
  g H = H = H g.
$
Suy ra $g H g^(-1) = H$.

*Trường hợp 2:* $g in.not H$.

Vì $[G : H] = 2$, nên $G$ có đúng hai lớp ghép trái phân biệt là $H$ và $g H$.

Theo tính chất phân hoạch của các lớp ghép trái, ta có
$
  G = H union g H,
  quad H inter g H = emptyset.
$
Do đó
$
  g H = G without H.
$

Tương tự, hai lớp ghép phải phân biệt là $H$ và $H g$, nên
$
  G = H union H g,
  quad H inter H g = emptyset.
$
Suy ra
$
  H g = G without H.
$

Vậy
$
  g H = G without H = H g.
$

Nhân hai vế bên phải với $g^(-1)$, ta được
$
  g H g^(-1) = H.
$

Từ hai trường hợp, suy ra
$
  forall g in G, quad g H g^(-1) = H.
$

Vậy $H$ là nhóm con chuẩn tắc của $G$.

*Nhận xét.* Trong chứng minh trên, ta không sử dụng giả thiết $G$ hữu hạn. Do đó, kết quả có thể tổng quát hóa như sau:

Với mọi nhóm $G$ và mọi nhóm con $H <= G$, nếu $[G : H] = 2$ thì $H$ là nhóm con chuẩn tắc của $G$.
  

*Định lý (Nhóm con có chỉ số là ước nguyên tố nhỏ nhất).* Cho $G$ là một nhóm hữu hạn và $p$ là ước nguyên tố nhỏ nhất của $|G|$. Khi đó, với mọi nhóm con $H <= G$, ta có
$
  [G : H] = p <=> H triangle.l G.
$

*Chứng minh.* Giả sử $[G : H] = p$.

Xét tập hợp các lớp ghép trái
$
  X = G\/H = brace.l g H : g in G brace.r.
$

Vì $[G : H] = p$, nên $|X| = p$.

Xét tác động của $G$ lên $X$ bằng phép nhân trái:
$
  g dot (x H) = (g x)H.
$

Tác động này cảm sinh một đồng cấu nhóm
$
  phi : G -> S_p.
$

Đặt $K = op("ker") phi$. Khi đó $K triangle.l G$.

Hơn nữa, nếu $k in K$ thì $k$ cố định mọi lớp ghép, đặc biệt $k H = H$. Suy ra $k in H$, nên
$
  K subset.eq H.
$

Theo định lý đẳng cấu thứ nhất,
$
  G\/K tilde.equiv op("Im") phi.
$

Do đó
$
  [G : K] = |op("Im") phi| mid p!.
$

Mặt khác, theo định lý Lagrange,
$
  [G : K] mid |G|.
$

Vì $p$ là ước nguyên tố nhỏ nhất của $|G|$, trong khi mọi ước nguyên tố của $p!$ đều không vượt quá $p$, nên
$
  [G : K] in brace.l 1, p brace.r.
$

Lại có $K subset.eq H subset.eq G$, nên theo công thức nhân chỉ số,
$
  [G : K] = [G : H][H : K] = p[H : K].
$

Suy ra $[G : K] >= p$, do đó
$
  [G : K] = p.
$

Vậy
$
  p[H : K] = p
  <=> [H : K] = 1
  <=> H = K.
$

Vì $K triangle.l G$, suy ra
$
  H triangle.l G.
$

Điều phải chứng minh.

*Nhận xét 1.* Khi $[G : H] = 2$, do $2$ là ước nguyên tố nhỏ nhất của $|G|$, định lý trên cho ngay $H triangle.l G$.

Tuy nhiên, trường hợp chỉ số $2$ vẫn đúng ngay cả khi $G$ là nhóm vô hạn.

*Nhận xét 2.* Không thể thay điều kiện "$p$ là ước nguyên tố nhỏ nhất của $|G|$" bằng "$p$ là số nguyên tố bất kỳ".

Thật vậy, xét
$
  G = S_3, quad H = chevron.l (12) chevron.r.
$

Ta có
$
  [G : H] = 6/2 = 3.
$

Mặc dù $3$ là số nguyên tố, nhưng $H$ không chuẩn tắc trong $S_3$, vì
$
  (13)(12)(13)^(-1) = (23) in.not H.
$

*Hệ quả.* Nếu $G$ là nhóm hữu hạn có cấp $p q$, với $p < q$ là hai số nguyên tố phân biệt, thì mọi nhóm con có cấp $q$ đều chuẩn tắc trong $G$.

Thật vậy, nếu $H <= G$ và $|H| = q$, thì theo định lý Lagrange,
$
  [G : H] = (p q)/q = p.
$

Do $p$ là ước nguyên tố nhỏ nhất của $|G|$, suy ra $H triangle.l G$.

]
#baitoan[
  *a)* Cho nhóm $G$ với tâm là $C(G)$. Chứng minh rằng nhóm thương $G \/ C(G)$ cyclic khi và chỉ khi $G$ giao hoán.

  *b)* Dùng kết quả câu a) để chứng minh rằng mọi nhóm hữu hạn cấp $p^2$ với $p$ nguyên tố đều giao hoán.
]
#loigiai[
  _Tâm_ của $G$ là tập hợp
$
C(G) = {x in G | x y = y x, forall y in G}.
$
*a)* Giả sử nhóm thương $G\/ C(G)$ cyclic,khi đó có $g in G$ sao cho $ G\/ C(G) = chevron.l g C(G) chevron.r $ ta chứng minh $G$ giao hoán. Thật vậy, lấy tùy ý $x,y in G$, ta chứng minh $x y = y x$. Vì $x C(G), y C(G) in G\/ C(G)$, nên có $m,n in ZZ$ sao cho $x C(G) =g^m C(G)$ và $y C(G)= g^n C (G)$. Do đó, có $a,b in C(G)$ sao cho $x=g^m a$ và $y=g^n b$. Suy ra , $x y= g^m a g^n b$, vì $a,b$ giao hoán với mọi phần tử trong $G$, nên $x y = g^m g^n a b =g^(m+n) a b =g^(n) b g^m a= y x$. Vậy, $G$ giao hoán.

*(<=)* Giả sử $G$ giao hoán, ta chứng minh $G \/ C(G)$ là nhóm cyclic. Thật vậy, vì $G$ giao hoán nên $C(G)=G$, do đó $G \/ C(G)={e}$, mà ${e}$ là nhóm cyclic, nên $G\/ C(G)$ là nhóm cyclic.
]
*b)*
 Giả sử $G$ là một nhóm hữu hạn có $|G| = p^2$, trong đó $p$ là số nguyên tố.

Ta chứng minh $G$ giao hoán bằng cách sử dụng kết quả câu a).

*Bước 1. Chứng minh $p | |C(G)|$.*

Theo phương trình lớp, ta có
$
  |G| = |C(G)| + sum_(i=1)^r [G : C_G(x_i)],
$
trong đó $x_1, dots, x_r$ là các đại diện của những lớp liên hợp không tầm thường và
$
  C_G(x_i) = brace.l
    g in G : g x_i = x_i g
  brace.r
$
là nhóm tâm hóa của $x_i$.

Vì $x_i in.not C(G)$, nên $C_G(x_i)$ là nhóm con thực sự của $G$.

Mặt khác, $x_i != e$ và
$
  chevron.l x_i chevron.r subset.eq C_G(x_i),
$
nên
$
  1 < |C_G(x_i)| < p^2.
$

Theo định lý Lagrange,
$
  |C_G(x_i)| | p^2.
$

Vì $p$ là số nguyên tố, suy ra
$
  |C_G(x_i)| = p.
$

Do đó
$
  [G : C_G(x_i)]
  = (|G|) / (|C_G(x_i)|)
  = p^2 / p = p.
$

Thay vào phương trình lớp, ta được
$
  p^2 = |C(G)| + r p.
$

Suy ra
$
  |C(G)| = p(p-r).
$

Vậy $p | |C(G)|$.

*Bước 2. Xét cấp của tâm $C(G)$.*

Vì $C(G) <= G$, theo định lý Lagrange, ta có
$
  |C(G)| | |G| = p^2.
$

Kết hợp với $p | |C(G)|$, suy ra
$
  |C(G)| in brace.l p, p^2 brace.r.
$

Ta xét hai trường hợp:

*Trường hợp 1:* $|C(G)| = p^2$.

Khi đó $C(G) = G$. Theo định nghĩa tâm của nhóm, suy ra $G$ giao hoán.

*Trường hợp 2:* $|C(G)| = p$.

Vì $C(G)  triangle.l G$, ta xét nhóm thương $G\/C(G)$.

Theo định lý Lagrange,
$
  |G\/C(G)| = (|G|) / (|C(G)|)
  = p^2 / p = p.
$

Vì mọi nhóm có cấp nguyên tố đều là nhóm cyclic, nên $G\/C(G)$ là nhóm cyclic.

Áp dụng kết quả câu a), suy ra $G$ giao hoán.

Vậy trong cả hai trường hợp, $G$ đều giao hoán.

Do đó, mọi nhóm hữu hạn có cấp $p^2$, với $p$ nguyên tố, đều là nhóm Abel.

Điều phải chứng minh.

*Nhận xét.* Bước 1 là một trường hợp đặc biệt của định lý: Mọi $p$-nhóm hữu hạn không tầm thường đều có tâm không tầm thường.

Hơn nữa, trường hợp $|C(G)| = p$ dẫn đến $G$ giao hoán, tức là $C(G) = G$, mâu thuẫn với $|C(G)| = p$. Do đó, thực tế chỉ có thể xảy ra $|C(G)| = p^2$.
#baitoan[
  Cho nhóm $(G, .)$. Ta gọi _hoán tử_ của hai phần tử $x$ và $y$ trong $G$ là phần tử $[x, y] = x^(-1) y^(-1) x y$. Nhóm con của $G$ sinh bởi tất cả các hoán tử của các phần tử trong $G$ được gọi là _nhóm hoán tử_ của $G$ và được ký hiệu là $[G, G]$. Chứng minh rằng:

  *a)* $[G, G]$ là nhóm con chuẩn tắc của $G$.

  *b)* Với $H$ là nhóm con chuẩn tắc của $G$, nhóm thương $G \/ H$ giao hoán khi và chỉ khi $[G, G] subset.eq H$. Suy ra nhóm thương $G \/ [G, G]$ giao hoán.
]
#loigiai[

  *a)* Lấy $x in G$ và $y in [G,G]$. Khi đó, ta chứng minh $x^(-1) y x in [G,G]$. Theo định nghĩa, mọi $a,b$ có dạng $a^(-1) b^(-1) a b$ đều thuộc $[G,G]$, nên ta biến đổi $x^(-1) y x$, với $a= x$ và $b=y^(-1)$, ta được $x^(-1) ((y^(-1))^(-1) x y^(-1)) y =x^(-1)y x in [G,G]$.

  *b)* Với $H$ là nhóm con chuẩn tắc bất kỳ của $G$, ta có $G \/ H$ giao hoán tương đương
  $
  forall x,y in G : (x H)(y H)=(y H)(x H)\
  <=> forall x,y in G x^(-1) y^(-1) x h in H <=> [G,G] subset.eq H.
  $
  Vì $G \/H$ giao hoán nên suy ra $G \/ [G,G]$ giao hoán.
  
]
#baitoan[
  Xét nhóm hoán vị $S_4$. Chứng minh rằng tập hợp
  $ K = brace.l op("Id"), (12)(34), (13)(24), (14)(23) brace.r $
  là nhóm con chuẩn tắc của $S_4$ (Ta gọi $K$ là nhóm Klein).
]
#loigiai[
Xét nhóm hoán vị $S_4$. Chứng minh rằng tập hợp
$
  K = brace.l op("Id"), (12)(34), (13)(24), (14)(23) brace.r
$
là nhóm con chuẩn tắc của $S_4$ (gọi là nhóm Klein).

*Lời giải.*

*[Cách 1. Sử dụng định nghĩa nhóm con chuẩn tắc và phép liên hợp.]*

Đặt
$
  e = op("Id"), quad
  a = (12)(34), quad
  b = (13)(24), quad
  c = (14)(23).
$

Khi đó $K = brace.l e, a, b, c brace.r$.

*Bước 1. Chứng minh $K <= S_4$.*

Ta có $e in K$. Mặt khác,
$
  a^2 = b^2 = c^2 = e.
$

Ngoài ra, bằng cách tính tích các hoán vị, ta được
$
  a b = b a = c, quad
  b c = c b = a, quad
  c a = a c = b.
$

Do đó $K$ đóng đối với phép nhân. Đồng thời, mọi phần tử của $K$ đều có nghịch đảo thuộc $K$.

Vậy $K <= S_4$.

*Bước 2. Chứng minh $K triangle.l S_4$.*

Ta cần chứng minh
$
  forall sigma in S_4, quad sigma K sigma^(-1) = K.
$

Nhắc lại tính chất của phép liên hợp trong nhóm hoán vị:
$
  sigma (i_1 i_2 dots i_r) sigma^(-1)
  = (sigma(i_1) sigma(i_2) dots sigma(i_r)).
$

Lấy $sigma in S_4$ tùy ý. Xét $a = (12)(34)$, ta có
$
  sigma a sigma^(-1)
  = (sigma(1) sigma(2))(sigma(3) sigma(4)).
$

Vì $sigma$ là một hoán vị của $brace.l 1, 2, 3, 4 brace.r$, nên $sigma(1), sigma(2), sigma(3), sigma(4)$ đôi một phân biệt.

Do đó $sigma a sigma^(-1)$ là tích của hai phép đổi chỗ rời nhau.

Mặt khác, trong $S_4$ chỉ có đúng ba hoán vị có dạng tích của hai phép đổi chỗ rời nhau, đó là
$
  (12)(34), quad (13)(24), quad (14)(23).
$

Suy ra
$
  sigma a sigma^(-1) in K.
$

Lập luận tương tự đối với $b,c$, ta được
$
  sigma b sigma^(-1) in K,
  quad sigma c sigma^(-1) in K.
$

Ngoài ra,
$
  sigma e sigma^(-1) = e in K.
$

Vậy
$
  sigma K sigma^(-1) subset.eq K.
$

Vì phép liên hợp bởi $sigma$ là một song ánh trên $S_4$, nên
$
  |sigma K sigma^(-1)| = |K| = 4.
$

Do đó
$
  sigma K sigma^(-1) = K.
$

Vì $sigma in S_4$ tùy ý, suy ra
$
  K triangle.l S_4.
$

Điều phải chứng minh.

*[Cách 2. Sử dụng các lớp liên hợp.]*

Trước hết, bằng cách kiểm tra phép nhân và phép lấy nghịch đảo như ở cách 1, ta có $K <= S_4$.

Ta biết rằng hai hoán vị trong $S_n$ liên hợp với nhau khi và chỉ khi chúng có cùng kiểu chu trình.

Trong $S_4$, ba hoán vị
$
  (12)(34), quad (13)(24), quad (14)(23)
$
đều có kiểu chu trình $(2,2)$.

Hơn nữa, đây là tất cả các hoán vị trong $S_4$ có kiểu chu trình $(2,2)$.

Do đó, chúng tạo thành một lớp liên hợp:
$
  op("Cl")_(S_4)((12)(34))
  = brace.l (12)(34), (13)(24), (14)(23) brace.r.
$

Mặt khác, phần tử đơn vị tạo thành một lớp liên hợp riêng:
$
  op("Cl")_(S_4)(e) = brace.l e brace.r.
$

Suy ra
$
  K = op("Cl")_(S_4)(e)
    union op("Cl")_(S_4)((12)(34)).
$

Như vậy, $K$ là hợp của hai lớp liên hợp trong $S_4$.

Theo định lý, một nhóm con $H <= G$ là chuẩn tắc trong $G$ khi và chỉ khi $H$ là hợp của một số lớp liên hợp của $G$.

Vì $K <= S_4$ và $K$ là hợp của các lớp liên hợp trong $S_4$, nên
$
  K triangle.l S_4.
$

Điều phải chứng minh.

*Nhận xét.* Ta có
$
  K tilde.equiv ZZ_2 times ZZ_2.
$

Vì vậy, $K$ là một nhóm Abel có $4$ phần tử nhưng không phải nhóm cyclic. Nhóm này được gọi là nhóm Klein, thường ký hiệu $V_4$.
  
]
#baitoan[
  Chứng minh rằng:

  *a)* Nhóm hoán vị $S_n$ được sinh bởi các chuyển vị.

  *b)* Nhóm thay phiên $A_n$ là nhóm con chuẩn tắc của $S_n$ và được sinh bởi các 3-chu trình.

  *c)* Nếu $H$ là một nhóm con chuẩn tắc của $A_n$ và $H$ có chứa ít nhất một 3-chu trình thì $H = A_n$.
]
#loigiai[
  *a)* Hiển nhiên, vì các hoán vị luôn có thể viết thành tích của các chuyển vị.

  *b)* Do $A_n$ là tập hợp tất cả các hoán vị chẵn, nên $A_n$ luôn được sinh ra bới 
]
#baitoan[
  Cho $(G, .)$ là một nhóm giao hoán. Chứng minh rằng ánh xạ $f : x -> x^k$ với $k$ là một số nguyên cho trước, là một đồng cấu nhóm. Hãy xác định $op("Ker") f$.
]
#loigiai[

  Có $f$ là đồng cấu, vì với mỗi $x,y in G$. Ta có $f(x y)=(x y)^k$ do $G$ giao hoán nên $(x y)^k= x^k y^k= f(x) f(y)$. Do đó, $f$ là đồng cấu nhóm. Hơn nữa, $K e r f={x in G : f(x)=e}={x in G : x^k=e }={x in G : o r d (x) | k }$.
]
#baitoan[
  Cho $(G, .)$ là một nhóm. Chứng minh rằng ánh xạ $f: x -> x^(-1)$ là một tự đẳng cấu của nhóm $G$ khi và chỉ khi $G$ giao hoán.
]
#loigiai[

  Giả sử $f$ là một tự đẳng cấu, khi đó ta chứng minh $G$ giao hoán. Thật vậy, lấy $x,y in G$, khi đó ta có, $f(x y)=(x y)^(-1)= f(x) f(y)= x^(-1) y^(-1) <=> y^(-1) x^(-1)=x^(-1) y^(-1)<=> x y= y x$, do đó $G$ giao hoán.

  Giả sử $G$ giao hoán, ta chứng minh $f$ là tự đẳng cấu. Thật vậy, ta chứng minh $f$ là đồng cấu, lấy $x,y in G$, có $f(x y)=y^(-1) x^(-1)= x^(-1) y^(-1)=f(x) f(y)$. Hơn nữa, có $k e r f={x in G : f(x)=e} = {x in G : x^(-1)=e}$. Với $x in G$, nếu $x!= e$, thì $x^(-1)!=e$, do đó $x^(-1)=e <=> x=e$, vậy $k e r f={e}$, nên $f$ là đơn cấu. Ta chứng minh $f$ là toàn ánh, lấy $y in G$, khi đó $y=f(x) <=> y=x^(-1)$. Vì $y=x^(-1) $, nên luôn tìm được $x in G $ sao cho $y= x^(-1)$. Vậy $f$ là tự đẳng cấu.
]
#baitoan[
  Xét đồng cấu nhóm cộng $f : ZZ -> ZZ$. Chứng minh rằng:

  *a)* $op("Im") f$ có dạng $n ZZ$ với $n in NN$.

  *b)* $op("Ker") f = brace.l 0 brace.r$ hoặc $op("Ker") f = ZZ$.

  *c)* Tìm tất cả các tự đồng cấu của nhóm cộng $ZZ$.
]
#loigiai[
  
  *a)* Ta chứng minh $I m f=n ZZ$, thật vậy do $I m f <=Z$, nên $ i m f = n ZZ$. 

  *b)* Do $f$ là một đồng cấu nhóm cộng nên $forall n in ZZ$, ta đều có $f(n)= n f(1)$. Nếu $f(1)=0$, thì $f (n)=0 , forall n in ZZ$. Do đó, $k e r f= NN$. Nếu $f(1)!=0$, thì $n$ phải bằng $0$. Nên $k e r f={0}$.

  *c)* Các tự đẳng cấu của nhóm cộng $ZZ$. Với mỗi $k in ZZ$, định nghĩa
  $
  f_k : ZZ -> ZZ , f_k (n)= k n
  $
  Dễ thấy $f_k$ là đồng cấu, hơn nữa các tự đồng cấu $f$ đều có dạng $f(n)=n f(1)$. Đặt $k= f(1) in ZZ$, ta được $f= f_k$. Do đó, tập hợp các tự đồng cấu của nhóm cộng $ZZ$ là :

  $
  E n d (ZZ)={f_k : k in ZZ, f_k (n) =k n}
  $
]
#baitoan[
  Xét đồng cấu nhóm cộng $f : QQ -> ZZ$.

  *a)* Chứng minh rằng với $n in NN^*$, $f(1) = n f(1/n)$.

  *b)* Suy ra $f(1) = 0$ và $f$ phải là đồng cấu tầm thường. 
]
#loigiai[

  *a)* Với mỗi $n in NN^*$, ta có $f(1)=f(1/n + 1/n ... 1/n). n$

  *b)* Nếu $f(1)=0$ thì $f(1/n)=0$, do đó với mỗi $m in ZZ$ và $forall n in NN^*$ thì $f(m /n)=f (1/n) m=0$ thì hiển nhiên $f$ là đồng cấu tầm thường.
]
#baitoan[
  Hãy mô tả tất cả các tự đồng cấu $f : ZZ_12 -> ZZ_12$.
]
#loigiai[
*1. Xác định tất cả các tự đồng cấu.*

Xét một tự đồng cấu nhóm
$
  f : ZZ_12 -> ZZ_12.
$

Vì $ZZ_12 = chevron.l overline(1) chevron.r$, nên mọi phần tử của $ZZ_12$ đều có dạng
$
  overline(n) = n overline(1).
$

Do $f$ là đồng cấu nhóm, ta có
$
  f(overline(n)) = n f(overline(1)).
$

Đặt $f(overline(1)) = overline(k)$, với $k in brace.l 0, 1, dots, 11 brace.r$. Khi đó
$
  f(overline(n)) = overline(k n).
$

Ngược lại, với mỗi $k in brace.l 0, 1, dots, 11 brace.r$, định nghĩa ánh xạ
$
  f_k : ZZ_12 -> ZZ_12,
  quad f_k(overline(n)) = overline(k n).
$

Ta chứng minh $f_k$ là một đồng cấu nhóm.

Trước hết, $f_k$ xác định tốt. Thật vậy, nếu $overline(n) = overline(m)$, thì
$
  12 | (n-m)
  => 12 | k(n-m)
  => overline(k n) = overline(k m).
$

Mặt khác, với mọi $overline(a), overline(b) in ZZ_12$, ta có
$
  f_k (overline(a) + overline(b))
  &= overline(k(a+b)) \
  &= overline(k a) + overline(k b) \
  &= f_k (overline(a)) + f_k (overline(b)).
$

Vậy $f_k$ là một tự đồng cấu của $ZZ_12$.

Do đó, tập hợp tất cả các tự đồng cấu của $ZZ_12$ là
$
  op("End")(ZZ_12)
  = brace.l f_0, f_1, dots, f_11 brace.r,
$
trong đó
$
  f_k (overline(n)) = overline(k n),
  quad k = 0, 1, dots, 11.
$

Như vậy, nhóm cộng $ZZ_12$ có đúng $12$ tự đồng cấu.

*2. Xác định hạt nhân và ảnh của các tự đồng cấu.*

Với mỗi $k in brace.l 0, 1, dots, 11 brace.r$, đặt
$
  d = gcd(k, 12),
$
trong đó quy ước $gcd(0, 12) = 12$.

Theo định nghĩa hạt nhân,
$
  op("ker") f_k
  &= brace.l overline(n) in ZZ_12 :
    f_k(overline(n)) = overline(0) brace.r \
  &= brace.l overline(n) in ZZ_12 :
    12 | k n brace.r.
$

Vì $d = gcd(k,12)$, ta có
$
  12 | k n <=> 12/d | n.
$

Suy ra
$
  op("ker") f_k
  = chevron.l overline(12/d) chevron.r.
$

Do đó
$
  |op("ker") f_k| = d.
$

Mặt khác,
$
  op("Im") f_k
  &= brace.l overline(k n) : n in ZZ brace.r \
  &= chevron.l overline(k) chevron.r \
  &= chevron.l overline(d) chevron.r.
$

Vì cấp của $overline(k)$ trong $ZZ_12$ là $12/d$, nên
$
  |op("Im") f_k| = 12/d.
$

Ta có bảng sau:

#align(center)[#table(
  columns: 4,
  align: center,
  inset: 6pt,
  stroke: 0.5pt + gray,
  [*$k$*], [*$gcd(k,12)$*],
  [*$|op("ker") f_k|$*], [*$|op("Im") f_k|$*],

  [0], [12], [12], [1],
  [1], [1], [1], [12],
  [2], [2], [2], [6],
  [3], [3], [3], [4],
  [4], [4], [4], [3],
  [5], [1], [1], [12],
  [6], [6], [6], [2],
  [7], [1], [1], [12],
  [8], [4], [4], [3],
  [9], [3], [3], [4],
  [10], [2], [2], [6],
  [11], [1], [1], [12],
)
]



*3. Xác định tất cả các tự đẳng cấu của $ZZ_12$.*

Một tự đồng cấu $f_k$ là tự đẳng cấu khi và chỉ khi $f_k$ đơn ánh, tức là
$
  op("ker") f_k = brace.l overline(0) brace.r.
$

Điều này tương đương với
$
  |op("ker") f_k| = 1
  <=> gcd(k, 12) = 1.
$

Vì $k in brace.l 0, 1, dots, 11 brace.r$, nên
$
  gcd(k, 12) = 1
  <=> k in brace.l 1, 5, 7, 11 brace.r.
$

Do đó
$
  op("Aut")(ZZ_12)
  = brace.l f_1, f_5, f_7, f_11 brace.r.
$

Như vậy, $ZZ_12$ có đúng $phi(12) = 4$ tự đẳng cấu, trong đó $phi$ là hàm Euler.

*4. Tổng quát hóa.*

Với mọi số nguyên dương $n$, tất cả các tự đồng cấu của nhóm cộng $ZZ_n$ đều có dạng
$
  f_k : ZZ_n -> ZZ_n,
  quad f_k(overline(x)) = overline(k x),
$
với $k in brace.l 0, 1, dots, n-1 brace.r$.

Hơn nữa, ta có
$
  f_k in op("Aut")(ZZ_n)
  <=> gcd(k,n) = 1.
$

Vì vậy, số tự đẳng cấu của $ZZ_n$ bằng $phi(n)$.

Ngoài ra, tập hợp các tự đồng cấu của $ZZ_n$ tạo thành một vành với phép cộng ánh xạ và phép hợp thành, đồng thời
$
  op("End")(ZZ_n) tilde.equiv ZZ_n
$
theo nghĩa đẳng cấu vành.

Thật vậy, với mọi $k,l in ZZ_n$, ta có
$
  (f_k + f_l)(overline(x))
  = overline((k+l)x)
$
và
$
  (f_k compose f_l)(overline(x))
  = overline(k l x).
$

Do đó
$
  f_k + f_l = f_(k+l),
  quad f_k compose f_l = f_(k l),
$
trong đó các chỉ số được hiểu theo modulo $n$.

Đặc biệt, đối với nhóm $ZZ_12$, ta có
$
  op("Aut")(ZZ_12)
  tilde.equiv ZZ_2 times ZZ_2.
$

*Nhận xét.* Vì $ZZ_n$ là nhóm cyclic sinh bởi $overline(1)$, nên mọi tự đồng cấu của $ZZ_n$ được xác định hoàn toàn bởi ảnh của phần tử sinh $overline(1)$.
  
]
#baitoan[
  Cho $G$ là một nhóm và $f : G -> G$ là một ánh xạ xác định bởi $f(a) = a^(-1)$, $forall a in G$. Chứng minh rằng $G$ abel khi và chỉ khi $f$ là một đồng cấu.
]
#loigiai[

  *(=>)* Giả sử $G$ abel, khi đó ta chứng minh $f$ là đồng cấu. Thật vậy, lấy tùy ý $x,y in G$, có $f(x y)= (x y)^(-1) = y^(-1) x^(-1) = x^(-1) y^(-1)=f(x) f(y)$ do $G$ abel nên $f$ là đồng cấu.

  *(<=)* Giả sử $f$ là đồng cấu, khi đó , lấy $x,y in G$, ta chứng minh $x y = y x$, vì $f$ là đồng cấu nên $f(x y)=(y x) ^(-1)= x^(-1) y^(-1) <=> x y = y x$. Vậy $G$ abel.
]
#baitoan[
  Chứng minh rằng:

  *a)* Mọi nhóm cyclic hữu hạn cấp $n$ đều đẳng cấu với nhóm $(ZZ_n, +)$.

  *b)* Mọi nhóm cyclic vô hạn đều đẳng cấu với nhóm $(ZZ, +)$.
]
#loigiai[
  
*a)*
  Đặt $G$ là nhóm cyclic sinh bởi $a$, khi đó $|G|= n$. Xét ánh xạ : 
  $
  f: ZZ &-> G\ k &-> a^k
  $
  Khi đó ta chứng minh $f$ là đẳng cấu.

  Thật vậy, lấy $x,y in ZZ$ xét $f(x y)= a^(x y)=a ^x$
  
]
#baitoan[
  Chứng minh rằng tồn tại duy nhất (sai khác một đẳng cấu) một nhóm hữu hạn cấp $8$ sinh bởi hai phần tử $a, b$ thỏa hệ thức
  $ a^4 = e, quad b a = a^(-1) b, quad a^2 = b^2. $

  Nhóm này được gọi là _nhóm Quaternion_.

  _Hướng dẫn:_ Chứng minh sự tồn tại của nhóm bằng cách xét nhóm con của nhóm $op("GL")(2, CC)$ sinh bởi hai ma trận
  $ a = mat(0, 1; -1, 0) quad "và" quad b = mat(0, i; i, 0). $
]

#baitoan[
  Chứng minh rằng mọi nhóm con của nhóm quaternion đều chuẩn tắc.
]

#baitoan[
  Chứng minh rằng với mỗi số nguyên dương $n$ tồn tại duy nhất (sai khác một đẳng cấu) một nhóm hữu hạn cấp $2n$ sinh bởi hai phần tử $a, b$ thỏa hệ thức
  $ a^2 = e, quad b^n = e, quad a b = b^(-1) a. $

  Nhóm này được gọi là _nhóm nhị diện_ $D_n$.

  _Hướng dẫn:_ Chứng minh sự tồn tại của nhóm bằng cách xét nhóm con của nhóm $op("GL")(2, CC)$ sinh bởi hai ma trận
  $ a = mat(0, 1; 1, 0) quad "và" quad b = mat(zeta, 0; 0, zeta^(-1)), $
  trong đó $zeta$ là một căn nguyên thủy bậc $n$ của $1$.
]

#baitoan[
  Chứng minh rằng trong nhóm nhị diện $D_n$ với $n >= 3$ nhóm con $chevron.l b chevron.r$ chuẩn tắc nhưng nhóm con $chevron.l a chevron.r$ thì không.
]

#baitoan[
  *a)* Cho $G$ là một nhóm hữu hạn có cấp $|G| <= 5$. Chứng minh $G$ giao hoán.

  *b)* Cho $G$ là một nhóm hữu hạn có cấp $6$. Chứng minh rằng nếu $G$ giao hoán thì $G$ là nhóm cyclic đẳng cấu với $ZZ_6$; nếu $G$ không giao hoán thì $G$ đẳng cấu với nhóm nhị diện $D_3$.
]

#loigiai[

  *a)* Do $G$ là nhóm hữu hạn và cấp của $G<=5$, nên có $|G| in {1,2,3,4,5}$. Nếu $|G| in {1,2,3,5}$ thì $G$ là nhóm cyclic nên $G$ giao hoán. Nếu $|G|=4$, thì nếu $G$ là nhóm cyclic, thì $G$ giao hoán, nếu $G$ không là nhóm cyclic thì mọi phần tử $in G$ khác $e$ đều có cấp $2$, nên $G$ giao hoán.
]
#baitoan[
  Chứng minh rằng:

  *a)* $op("GL")(n, RR) \/ op("SL")(n, RR) tilde.equiv RR^*$.

  *b)* Nhóm thương $RR \/ ZZ$ đẳng cấu với nhóm nhân $T$ gồm các số phức có môđun bằng $1$.
]
#loigiai[

  *a)* Xét ánh xạ $
  f : G L(n,RR) &-> RR^*\
        A &-> f(A)=det(A)
  $

  Ta chứng minh $f$ đồng cấu. Thật vậy, có $f$ là đồng cấu, lấy $A,B in G L(n,RR) => det(A)!=0 ,det(B)!=0$.Hơn nữa,
  $
  f(A B)=det(A B)=det(A) det(B)=f(A) f(B)
  $
  Do đó, $f$ là đồng cấu nhóm.

  Hơn nữa, $ker f={ A in G L (n,RR) : f(A)= 1 <=> det(A)=1} <=> ker f= S L(n,RR)$. Ta chứng minh $f$ là toàn ánh. Thật vậy, lấy $y in RR^*$, khi đó chọn ma trận $A$ là ma trận đường chéo với phần tử đầu tiên là $y$ còn lại là $1$, thì $A in G L(n,RR)$. Do đó, $f$ toàn cấu. Mặt khác, $S L(n,RR)$ là nhóm thương của $G L (n,RR)$, nên $G L(n,RR) \/ S L (n,RR)$ xác định và theo định lý đẳng cấu thứ nhất.
  $
  G L (n,RR) \/ S L(n,RR) tilde.equiv RR^*
  $
]
#baitoan[
  Cho nhóm cyclic $G = chevron.l x chevron.r$ hữu hạn cấp $n$.

  *a)* Với $f : G -> G'$ là một đồng cấu nhóm, đặt $y = f(x)$. Chứng minh $y^n = e$, nghĩa là, $y$ có cấp là một ước số của $n$.

  *b)* Chứng minh rằng tương ứng $f |-> f(x)$ là một song ánh giữa tập các đồng cấu nhóm từ $G$ vào $G'$ và tập các phần tử $y$ của $G'$ có cấp là ước số của $n$.
]
#loigiai[

  *a)* Do $|G|=n$, nên lấy tùy ý $x in G$, ta đều có $x^n =e => f(x^n)=f(e)<=> y^n =e_G'$, do đó $ |y| | n$.

  *b)*
]
#baitoan[
  Chứng minh rằng với đồng cấu $f : G -> G'$ từ một nhóm hữu hạn $G$ vào một nhóm $G'$, ta có:

  *a)* Cấp của $x in G$ chia hết cho cấp của $f(x)$.

  *b)* Cấp của $G$ chia hết cho cấp của $op("Im") f$.
]
#loigiai[

  *a)* Lấy bất kỳ $x in G$, do $G$ hữu hạn, nên ta đặt $m=o r d (x)$,$|G|=n$, và $|f(x)|=k$
  $
  x^m=e <=> f(x^m)=f(e) <=> f(x)^m=e_G' => k | m
  $

  *b)* Theo định lý đẳng cấu thứ nhất, $I m f tilde.equiv G \/ K e r f$, do đó :
  $
  |I m f|=[G : K e r f]
  $
  Mà theo định lý Largange, $[G : K e r f] |  G => |I m f| | G$.
]
#baitoan[
  Chứng minh rằng nhóm $G'$ là ảnh đồng cấu của một nhóm cyclic hữu hạn $G$ khi và chỉ khi $G'$ là nhóm cyclic hữu hạn có cấp chia hết cho cấp $G$.
]
#loigiai[
  *=>)* Giả sử $G'$ là ảnh đồng cấu của một nhóm cyclic hữu hạn $G$. Ta chứng minh $G'$ là nhóm cyclic hữu hạn có cấp chia hết cho cấp $G$.

  Gọi $|G|=n$, ta chứng minh $|G'|=m | n$. Thật vậy, từ $f(G)={f(x) : x in G}$. Đặt $G=chevron.l g chevron.r$, khi đó có $f(G)={f(g^k): k in ZZ}={(f(g)^k : k in ZZ}$. Do đó, $f(G)=chevron.l f(g) chevron.r$.
]
#baitoan[
  Ký hiệu $CC^*$ là nhóm nhân các số phức khác $0$. Chứng minh rằng nếu $H$ là nhóm con có chỉ số hữu hạn trong $CC^*$ thì $H = CC^*$.
]

#baitoan[
  Cho $G_1, G_2$ là hai nhóm với các phần tử đơn vị lần lượt là $e_1, e_2$. Xét tích trực tiếp $G = G_1 times G_2$ và các tập con $H_1 = G_1 times brace.l e_2 brace.r$ và $H_2 = brace.l e_1 brace.r times G_2$. Chứng minh rằng:

  *a)* Các phép chiếu $p_j : G -> G_j$ định bởi $p_j(x_1, x_2) = x_j$ là các toàn cấu nhóm và $op("Ker") p_1 = H_2$, $op("Ker") p_2 = H_1$. Suy ra $H_j$ là nhóm con chuẩn tắc của $G$ $(j = 1, 2)$.

  *b)* Các phép nhúng $i_1 : G_1 -> G$ định bởi $i_1(x_1) = (x_1, e_2)$ và $i_2 : G_2 -> G$ định bởi $i_2(x_2) = (e_1, x_2)$ là các đơn cấu nhóm và $op("Im") i_1 = H_1$, $op("Im") i_2 = H_2$.

  *c)* $G \/ H_1 tilde.equiv H_2$ và $G \/ H_2 tilde.equiv H_1$.

  *d)* $G = H_1 H_2$ và $H_1 inter H_2 = brace.l (e_1, e_2) brace.r$.

  Mở rộng kết quả trên cho tích trực tiếp $G_1 times G_2 times dots times G_n$.
]

#baitoan[
  Cho nhóm $(G, .)$.

  *a)* Chứng minh rằng tập hợp tất cả các tự đẳng cấu của $G$ cùng với phép toán tích các ánh xạ là một nhóm. Ta ký hiệu nhóm này là $op("Aut")(G)$.

  *b)* Với mỗi $g in G$, ánh xạ $phi_g : x |-> g x g^(-1)$ là một tự đẳng cấu của $G$. Ta gọi đây là các _tự đẳng cấu trong_ của $G$.

  *c)* Gọi $op("Int")(G)$ là tập tất cả các tự đẳng cấu trong của $G$. Chứng minh rằng $op("Int")(G)$ là một nhóm con chuẩn tắc của $op("Aut")(G)$.

  *d)* Chứng minh $G \/ C(G) tilde.equiv op("Int")(G)$, trong đó $C(G)$ là tâm của $G$.
]

#loigiai[

  *a)* 
]
#baitoan[
  Cho $f$ là một đẳng cấu từ nhóm $(G, .)$ đến nhóm $(G', .)$.

  *a)* Chứng minh rằng tương ứng $H |-> f(H)$ là một song ánh giữa tập hợp các nhóm con của $G$ và của $G'$.

  *b)* Chứng minh rằng tương ứng $H |-> f(H)$ là một song ánh giữa tập hợp các nhóm con chuẩn tắc của $G$ và của $G'$.

  *c)* Giả sử $H$ là một nhóm con chuẩn tắc của $G$. Chứng minh rằng tương ứng $x H |-> f(x) f(H)$ là một đẳng cấu từ nhóm thương $G \/ H$ đến nhóm thương $G' \/ f(H)$.
]

#baitoan[
  Xét ánh xạ $f : ZZ -> ZZ$ định bởi $f(x) = n x$, trong đó $n in NN^*$ cho trước. Chứng minh rằng:

  *a)* $f$ là một đồng cấu nhóm cộng. Tìm $op("Im") f$ và $op("Ker") f$.

  *b)* $f$ là một đẳng cấu nhóm cộng từ $ZZ$ đến $n ZZ$. Từ đó, hãy mô tả tất cả các nhóm con của nhóm $n ZZ$.

  *c)* Với $m in NN$, $ZZ \/ (m ZZ) tilde.equiv (n ZZ) \/ (m n ZZ)$.
]
#loigiai[
  *a)* Lấy $x,y in ZZ$, khi đó ta có $f(x+y)=n(x+y)=n(x)+n(y)=f(x)+f(y)$. Do đó, $f$ là đồng cấu nhóm cộng. Mặt khác, có $K e r f={x in ZZ : f(x)=0}={x in Z: f(x)=0}={1^k : k in ZZ , f(1^k)={0}={}$
]
#baitoan[
  Cho $(G, .)$ là một nhóm hữu hạn cấp $n$. Chứng minh rằng ánh xạ $x |-> f_x$, trong đó $f_x$ thuộc nhóm hoán vị $S(G)$ của $G$ định bởi $f_x(y) = x y$ với mọi $y in G$, là một đơn cấu từ nhóm $G$ vào nhóm $S(G)$. Từ đó suy ra rằng mọi nhóm hữu hạn đều là nhóm con (sai khác một đẳng cấu) của các nhóm hoán vị.
]

#baitoan[
  Cho $G, G'$ lần lượt là hai nhóm cyclic hữu hạn cấp $m$ và $n$ với các phần tử sinh lần lượt là $x$ và $y$. Xét tương ứng $f : G -> G'$ định bởi $f(x^k) = y^(k l)$ với mọi $k in NN$, trong đó $l in NN^*$ cho trước.

  *a)* Chứng minh rằng $f$ là một đồng cấu nhóm khi và chỉ khi $m l$ chia hết cho $n$.

  *b)* $f$ là một đẳng cấu nhóm khi và chỉ khi $m = n$ và $(m, l) = 1$.

  *c)* Áp dụng tìm tất cả các đồng cấu từ nhóm cyclic cấp $8$ đến nhóm cyclic cấp $12$ và từ nhóm cyclic cấp $12$ đến nhóm cyclic cấp $8$.

  *d)* Áp dụng tìm tất cả các tự đẳng cấu của nhóm cyclic cấp $8$.
]

#baitoan[
  *a)* Cho nhóm $(G, .)$ và $G_1, G_2, dots, G_n$ là các nhóm con chuẩn tắc của $G$ thỏa các điều kiện sau:
  $
    G = G_1 G_2 dots G_n quad "và" quad
    G_i inter (G_1 dots G_(i-1) G_(i+1) dots G_n) = brace.l e brace.r,
    quad forall 1 <= i <= n.
  $
  Chứng minh rằng:

  *i)* Mọi phần tử $x in G$ được viết duy nhất dưới dạng $x = x_1 x_2 dots x_n$ trong đó $x_i in G_i$, $forall 1 <= i <= n$.

  *ii)* $G$ đẳng cấu với nhóm tích trực tiếp $G_1 times G_2 times dots times G_n$.

  Ta nói $G$ là một _nội tích trực tiếp_ của các nhóm con $G_i$, $1 <= i <= n$.

  *b)* Chứng minh rằng nếu nhóm $(G, .)$ đẳng cấu với tích trực tiếp của những nhóm con $H_i$, $1 <= i <= n$ thì trong $G$ sẽ tồn tại các nhóm con $G_i$ đẳng cấu với $H_i$ sao cho $G$ là nội tích trực tiếp của các nhóm con $G_i$, $1 <= i <= n$.
]

#baitoan[
  Chứng minh rằng mọi nhóm hữu hạn cấp $p^2$ với $p$ nguyên tố hoặc đẳng cấu với nhóm $ZZ_(p^2)$ hoặc đẳng cấu với nhóm $ZZ_p times ZZ_p$.
]
#pagebreak()
= Vành,Miền Nguyên,Trường
// CHƯƠNG 2 — VÀNH, MIỀN NGUYÊN, TRƯỜNG


// Bài 2.1
#baitoan[
Kiểm chứng các cấu trúc đại số sau có là vành, miền nguyên hay trường không:

a) $cal(P)(X)$ với $X$ là tập hợp khác rỗng, và hai phép toán tương ứng là $triangle.stroked.t$ và $inter$ (ở đây $A triangle.stroked.t B = (A ∖ B) union (B ∖ A)$).

b) $QQ$ với hai phép toán $x top y = x + y - 1$ và $x bot y = x + y - x y$.

c) $RR^+$ với hai phép toán $x top y = x y$ và $x bot y = x^(ln y)$.

d) $RR$ với hai phép toán $x top y = root(n, x^n + y^n)$ và $x bot y = x y$ ($n$ là một số nguyên dương lẻ).

e) $RR$ với hai phép toán $x top y = (root(n, x) + root(n, y))^n$ và $x bot y = x y$ ($n$ là một số nguyên dương lẻ).

f) $ZZ(sqrt(2)) = {a + b sqrt(2) | a, b in ZZ}$ với hai phép toán là phép cộng và nhân thông thường như trong $RR$.

g) $QQ(sqrt(2)) = {a + b sqrt(2) | a, b in QQ}$ với hai phép toán là phép cộng và nhân thông thường như trong $RR$.

h) $K = {mat(a, b; 4 b, a) | a, b in QQ}$ với hai phép toán là phép cộng và phép nhân ma trận thông thường.

i) Tập hợp $A$ gồm tất cả các ma trận (tương ứng, ma trận chéo; ma trận tam giác trên; ma trận tam giác dưới; ma trận tam giác trên ngặt; ma trận tam giác dưới ngặt) vuông cấp $n >= 2$ với hai phép toán là phép cộng và phép nhân ma trận thông thường.

j) $F = {mat(a, b; 6 b, a) | a, b in QQ}$ với hai phép toán là phép cộng và phép nhân ma trận thông thường.

k) $CC = RR^2$ với hai phép toán định bởi $(x, y) + (z, t) = (x + z, y + t)$ và $(x, y)(z, t) = (x z - y t, x t + y z)$.
]
#loigiai[
*Câu 1.*

Cho $X != emptyset$. Với mọi $A,B,C subset.eq X$, các tập $A Delta B$ và $A inter B$ đều là tập con của $X$, nên hai phép toán *đóng* trên $cal(P)(X)$.

*1. Kiểm tra phép cộng $Delta$.*

- *Giao hoán:* Theo định nghĩa hiệu đối xứng, $A Delta B = B Delta A$.
- *Kết hợp:* Với mỗi $u in X$, phần tử $u$ thuộc $(A Delta B) Delta C$ khi và chỉ khi $u$ thuộc một số lẻ trong ba tập $A,B,C$. Điều kiện đó cũng tương đương $u in A Delta (B Delta C)$. Vì vậy $(A Delta B) Delta C = A Delta (B Delta C)$.
- *Phần tử không:* $A Delta emptyset = emptyset Delta A = A$; do đó $0_R = emptyset$.
- *Phần tử đối:* $A Delta A = emptyset$; do đó $-A=A$ đối với phép cộng mới.

Vậy $(cal(P)(X),Delta)$ là nhóm Abel.

*2. Kiểm tra phép nhân $inter$.*

- *Kết hợp:* $(A inter B) inter C = A inter (B inter C)$.
- *Giao hoán:* $A inter B = B inter A$.
- *Đơn vị:* $A inter X = X inter A=A$, nên $1_R=X$.
- *Phân phối:* Với mọi $u in X$, ta có
  $u in A inter (B Delta C)$ khi và chỉ khi $u in A$ và $u$ thuộc đúng một trong hai tập $B,C$. Điều này tương đương $u in (A inter B) Delta (A inter C)$. Vậy
  $
    A inter (B Delta C)
    = (A inter B) Delta (A inter C).
  $
  Do phép giao giao hoán, luật phân phối còn lại cũng đúng.

Suy ra $(cal(P)(X),Delta,inter)$ là *vành giao hoán có đơn vị*.

*3. Xét miền nguyên và trường.*

- Nếu $|X|=1$, viết $X={u}$, thì $cal(P)(X)={emptyset,X}$. Phần tử khác không duy nhất là $X$ và $X inter X=X$, nên $X$ tự nghịch đảo. Đây là một *trường* (và do đó là miền nguyên).
- Nếu $|X| >= 2$, lấy hai phần tử phân biệt $u,v in X$, đặt $A={u}$ và $B={v}$. Khi ấy $A != emptyset$, $B != emptyset$, nhưng $A inter B=emptyset$. Do đó vành có ước của không, không là miền nguyên, cũng không là trường.

*Kết luận:* Là vành với mọi $X != emptyset$; là miền nguyên và trường khi và chỉ khi $|X|=1$.

*Câu 2.*

Đặt $x top y=x+y-1$ và $x perp y=x+y-x y$.

*1. Tính đóng.* Với mọi $x,y in QQ$, ta có $x+y-1 in QQ$ và $x+y-x y in QQ$.

*2. Kiểm tra phép cộng $top$.*

- *Giao hoán:* $x top y=x+y-1=y+x-1=y top x$.
- *Kết hợp:*
  $
    (x top y) top z
    &= (x+y-1)+z-1 \
    &= x+y+z-2 \
    &= x+(y+z-1)-1=x top (y top z).
  $
- *Phần tử không:* Giải $x top z=x$, ta được $x+z-1=x$, nên $z=1$. Thật vậy, $x top 1=1 top x=x$. Vậy $0_R=1$.
- *Phần tử đối:* Giải $x top y=1$ được $y=2-x$. Vì $2-x in QQ$, mọi $x$ đều có phần tử đối là $2-x$.

Suy ra $(QQ,top)$ là nhóm Abel.

*3. Kiểm tra phép nhân $perp$.*

- *Giao hoán:* $x perp y=x+y-x y=y+x-y x=y perp x$.
- *Kết hợp:* Trước hết $x perp y=1-(1-x)(1-y)$. Vì vậy
  $
    (x perp y) perp z
    &=1-(1-(x perp y))(1-z) \
    &=1-(1-x)(1-y)(1-z) \
    &=x perp (y perp z).
  $
- *Đơn vị:* $x perp 0=x+0-x 0=x$, nên $1_R=0$ (số $0$ thông thường).
- *Phần tử không hấp thụ:* $x perp 1=x+1-x=1=0_R$.
- *Phân phối:*
  $
    x perp (y top z)
    &=x+(y+z-1)-x(y+z-1) \
    &=2 x+y+z-1-x y-x z \
    &=(x+y-x y)+(x+z-x z)-1 \
    &=(x perp y) top (x perp z).
  $
  Nhờ tính giao hoán của $perp$, luật phân phối bên phải cũng đúng.

Vậy đây là *vành giao hoán có đơn vị*.

*4. Nghịch đảo và ước của không.* Với $x != 0_R$, tức $x != 1$, giải $x perp y=1_R=0$:
$
  x+y-x y=0
  <=> y(x-1)=x
  <=> y=frac(x,x-1).
$
Vì $x in QQ$ và $x !=1$ nên $frac(x,x-1) in QQ$. Mọi phần tử khác không đều khả nghịch. Ngoài ra $1_R=0 !=1=0_R$ theo giá trị thông thường.

*Kết luận:* $(QQ,top,perp)$ là *trường*, do đó là miền nguyên và vành.

*Câu 3.*

Đặt $x top y=x y$ và $x perp y=x^(ln y)$, trong đó $x,y>0$.

*1. Tính đóng.* Tích $x y>0$; hơn nữa $x^(ln y)>0$. Vậy cả hai phép toán đều đóng trên $RR^+$.

*2. Kiểm tra phép cộng $top$.*

- *Giao hoán:* $x top y=x y=y x=y top x$.
- *Kết hợp:* $(x top y) top z=(x y)z=x(y z)=x top (y top z)$.
- *Phần tử không:* $x top 1=x$ nên $0_R=1$.
- *Phần tử đối:* Với mỗi $x>0$, ta có $x top frac(1,x)=1=0_R$. Do đó phần tử đối của $x$ là $1/x$, vẫn thuộc $RR^+$.

Vậy $(RR^+,top)$ là nhóm Abel.

*3. Kiểm tra phép nhân $perp$.*

- *Giao hoán:* Vì $x^(ln y)=e^((ln x)(ln y))=y^(ln x)$ nên $x perp y=y perp x$.
- *Kết hợp:*
  $
    (x perp y) perp z
    &=(x^(ln y))^(ln z) \
    &=x^((ln y)(ln z)) \
    &=x^(ln(y^(ln z)))=x perp (y perp z).
  $
- *Đơn vị:* $x perp e=x^(ln e)=x$, nên $1_R=e$ (cơ số của logarit tự nhiên).
- *Phần tử không hấp thụ:* $x perp 1=x^(ln 1)=1=0_R$.
- *Phân phối:*
  $
    x perp (y top z)
    &=x^(ln(y z)) \
    &=x^(ln y+ln z) \
    &=x^(ln y) x^(ln z) \
    &=(x perp y) top (x perp z).
  $
  Do $perp$ giao hoán, luật phân phối còn lại đúng.

Vậy ta được *vành giao hoán có đơn vị*.

*4. Nghịch đảo và ước của không.* Lấy $x !=0_R=1$. Khi đó $ln x !=0$. Chọn
$
  y=e^(1/(ln x))>0.
$
Ta có $x perp y=x^(ln y)=x^(1/(ln x))=e=1_R$. Do đó mọi phần tử khác không đều khả nghịch và $e !=1$.

*Kết luận:* Là *trường*, miền nguyên và vành.

*Câu 4.*

Đặt $x top y=root(n,x^n+y^n)$ và $x perp y=x y$. Vì $n$ lẻ, căn bậc $n$ của mọi số thực tồn tại duy nhất, đồng thời $root(n,a^n)=a$ với mọi $a in RR$.

*1. Tính đóng.* Với $x,y in RR$, tổng $x^n+y^n in RR$ có căn bậc $n$ thực; tích $x y in RR$.

*2. Kiểm tra phép cộng $top$.*

- *Giao hoán:* $root(n,x^n+y^n)=root(n,y^n+x^n)$.
- *Kết hợp:*
  $
    (x top y) top z
    &=root(n,(root(n,x^n+y^n))^n+z^n) \
    &=root(n,x^n+y^n+z^n) \
    &=x top (y top z).
  $
- *Phần tử không:* $x top 0=root(n,x^n)=x$, nên $0_R=0$.
- *Phần tử đối:* Do $n$ lẻ, $(-x)^n=-x^n$, nên $x top (-x)=root(n,0)=0$. Vậy phần tử đối của $x$ là $-x$.

Vậy $(RR,top)$ là nhóm Abel.

*3. Kiểm tra phép nhân $perp$.*

- *Kết hợp và giao hoán:* Vì $x perp y=x y$ là phép nhân số thực thông thường nên $(x perp y) perp z=x perp (y perp z)$ và $x perp y=y perp x$.
- *Đơn vị:* $x perp 1=x$, do đó $1_R=1$.
- *Phần tử không hấp thụ:* $x perp 0=0=0_R$.
- *Phân phối:* Vì $n$ lẻ,
  $
    x perp (y top z)
    &=x root(n,y^n+z^n) \
    &=root(n,x^n(y^n+z^n)) \
    &=root(n,(x y)^n+(x z)^n) \
    &=(x perp y) top (x perp z).
  $
  Luật phân phối bên phải suy ra từ tính giao hoán của phép nhân.

Suy ra đây là *vành giao hoán có đơn vị*.

*4. Nghịch đảo và ước của không.* Nếu $x != 0$ thì $1/x in RR$ và $x perp (1/x)=1$. Bởi vậy mọi phần tử khác không đều khả nghịch; đồng thời $1 !=0$.

*Kết luận:* Là *trường*, miền nguyên và vành, đối với mọi $n$ nguyên dương lẻ.

*Câu 5.*

Đặt $x top y=(root(n,x)+root(n,y))^n$ và $x perp y=x y$.

*1. Tính đóng.* Với $x,y in RR$, các căn bậc $n$ là số thực và $(root(n,x)+root(n,y))^n in RR$; tích $x y in RR$.

*2. Kiểm tra phép cộng $top$.*

- *Giao hoán:* Hoán đổi $x,y$ không làm đổi tổng hai căn, nên $x top y=y top x$.
- *Kết hợp:* Dùng $root(n,(a+b)^n)=a+b$ vì $n$ lẻ, ta có
  $
    (x top y) top z
    &=(root(n,(root(n,x)+root(n,y))^n)+root(n,z))^n \
    &=(root(n,x)+root(n,y)+root(n,z))^n \
    &=x top (y top z).
  $
- *Phần tử không:* $x top 0=(root(n,x)+0)^n=x$, nên $0_R=0$.
- *Phần tử đối:* $root(n,-x)=-root(n,x)$ vì $n$ lẻ, suy ra $x top (-x)=0$. Vậy phần tử đối là $-x$.

Vậy $(RR,top)$ là nhóm Abel.

*3. Kiểm tra phép nhân $perp$.*

- *Kết hợp, giao hoán, đơn vị và tính hấp thụ:* Đều đúng vì $perp$ là phép nhân số thực thông thường; cụ thể $1_R=1$ và $x perp 0=0$.
- *Phân phối:* Với $n$ lẻ, $root(n,x y)=root(n,x)root(n,y)$. Do đó
  $
    x perp (y top z)
    &=x(root(n,y)+root(n,z))^n \
    &=(root(n,x)root(n,y)+root(n,x)root(n,z))^n \
    &=(root(n,x y)+root(n,x z))^n \
    &=(x perp y) top (x perp z).
  $
  Luật phân phối còn lại suy ra từ tính giao hoán.

Vậy đây là *vành giao hoán có đơn vị*.

*4. Nghịch đảo và ước của không.* Với $x !=0$, phần tử $1/x$ thuộc $RR$ và $x perp (1/x)=1$. Mọi phần tử khác không đều khả nghịch.

*Kết luận:* Là *trường*, miền nguyên và vành, đối với mọi $n$ nguyên dương lẻ.

*Câu 6.*

Đặt $R={a+b sqrt(2) | a,b in ZZ}$, với phép cộng và nhân thông thường trong $RR$.

*1. Tính đóng.* Lấy $x=a+b sqrt(2)$ và $y=c+d sqrt(2)$, trong đó $a,b,c,d in ZZ$. Khi đó
$
  x+y=(a+c)+(b+d)sqrt(2) in R,
$
$
  x y=(a c+2 b d)+(a d+b c)sqrt(2) in R.
$

*2. Kiểm tra phép cộng.* Phép cộng giao hoán và kết hợp do kế thừa từ $RR$. Phần tử không $0=0+0 sqrt(2) in R$. Phần tử đối $-x=(-a)+(-b)sqrt(2) in R$. Vậy $(R,+)$ là nhóm Abel.

*3. Kiểm tra phép nhân và phân phối.* Phép nhân kết hợp, giao hoán và phân phối đối với phép cộng vì đó là các phép toán thông thường trong $RR$, đồng thời ta đã chứng minh tính đóng. Đơn vị nhân $1=1+0 sqrt(2) in R$ và $1 !=0$. Do vậy $R$ là *vành giao hoán có đơn vị*.

*4. Ước của không.* Nếu $x,y in R$ và $x y=0$, xét chúng là các số thực thì $x=0$ hoặc $y=0$. Vậy $R$ không có ước của không: $R$ là *miền nguyên*.

*5. Không là trường.* Phần tử $2=2+0 sqrt(2)$ khác không. Nếu $2$ có nghịch đảo trong $R$, tồn tại $a,b in ZZ$ sao cho
$
  2(a+b sqrt(2))=1
  <=> 2 a+2 b sqrt(2)=1.
$
Do $sqrt(2)$ vô tỉ, phải có $b=0$, rồi $a=1/2$, trái với $a in ZZ$. Vậy $2$ không khả nghịch trong $R$.

*Kết luận:* Là *miền nguyên nhưng không là trường*.

*Câu 7.*

Đặt $R={a+b sqrt(2) | a,b in QQ}$ với phép cộng và nhân thông thường.

*1. Tính đóng.* Với $x=a+b sqrt(2)$, $y=c+d sqrt(2)$, $a,b,c,d in QQ$,
$
  x+y=(a+c)+(b+d)sqrt(2) in R,
$
$
  x y=(a c+2 b d)+(a d+b c)sqrt(2) in R.
$

*2. Kiểm tra phép cộng.* Phép cộng kết hợp, giao hoán do kế thừa từ $RR$. Có $0=0+0 sqrt(2) in R$ và $-x=-a-b sqrt(2) in R$. Suy ra $(R,+)$ là nhóm Abel.

*3. Kiểm tra phép nhân và phân phối.* Phép nhân kết hợp, giao hoán, phân phối do kế thừa từ $RR$; đơn vị là $1=1+0 sqrt(2) in R$, khác $0$. Do đó $R$ là vành giao hoán có đơn vị.

*4. Kiểm tra nghịch đảo.* Lấy $x=a+b sqrt(2) !=0$. Ta có
$
  (a+b sqrt(2))(a-b sqrt(2))=a^2-2 b^2.
$
Nếu $a^2-2 b^2=0$ thì: khi $b=0$ suy ra $a=0$; còn khi $b !=0$ suy ra $(a/b)^2=2$, vô lý vì $sqrt(2) in.not QQ$. Vì thế $a^2-2 b^2 !=0$. Ta có
$
  x^(-1)
  =frac(a-b sqrt(2),a^2-2 b^2)
  =frac(a,a^2-2 b^2)-frac(b,a^2-2 b^2)sqrt(2) in R.
$
Khi đó $x x^(-1)=1$. Vậy mọi phần tử khác không đều khả nghịch.

*Kết luận:* $QQ(sqrt(2))$ là *trường*, do đó cũng là miền nguyên và vành.

*Câu 8.*

Đặt
$
  M(a,b)=mat(a,b;4 b,a), quad \
  K={M(a,b) | a,b in QQ}.
$

*1. Tính đóng.* Với $a,b,c,d in QQ$,
$
  M(a,b)+M(c,d)=M(a+c,b+d) in K.
$
Mặt khác,
$
  M(a,b)M(c,d)
  &=mat(a c+4 b d,a d+b c;4 (b c+a d),a c+4 b d) \
  &=M(a c+4 b d,a d+b c) in K.
$

*2. Kiểm tra phép cộng.* Nhờ tính đóng và các phép toán ma trận thông thường, phép cộng kết hợp, giao hoán; có ma trận không $M(0,0)$; và $-M(a,b)=M(-a,-b) in K$. Do đó $(K,+)$ là nhóm Abel.

*3. Kiểm tra phép nhân và phân phối.* Phép nhân kết hợp và phân phối vì là phép nhân ma trận thông thường và $K$ đóng dưới hai phép toán. Từ công thức tích,
$
  M(a,b)M(c,d)=M(c,d)M(a,b),
$
nên phép nhân còn giao hoán. Đơn vị nhân là $M(1,0)=I_2 in K$. Vậy $K$ là *vành giao hoán có đơn vị*.

*4. Ước của không.* Xét hai phần tử
$
  A=M(2,1)=mat(2,1;4,2), quad
  B=M(2,-1)=mat(2,-1;-4,2).
$
Ta có $A !=0$, $B !=0$, nhưng
$
  A B=M(2,1)M(2,-1)=M(4-4,-2+2)=M(0,0).
$
Do vậy $K$ có ước của không, không là miền nguyên. Hơn nữa, nếu $A$ có nghịch đảo $A^(-1)$ thì từ $A B=0$ suy ra $B=A^(-1)(A B)=0$, mâu thuẫn. Vậy $K$ không là trường.

*Kết luận:* Là *vành giao hoán có đơn vị, không là miền nguyên và không là trường*.

*Câu 9.*

Ta xét các ma trận có phần tử trên một trường $F$ (chẳng hạn $RR$ hoặc $QQ$). Ký hiệu $E_(i j)$ là ma trận có $1$ ở vị trí $(i,j)$ và $0$ tại mọi vị trí khác. Các phép toán là cộng và nhân ma trận thông thường.

*1. Tính đóng và tính chất của phép cộng.*

- *Ma trận chéo:* Tổng và tích của hai ma trận chéo vẫn là ma trận chéo.
- *Ma trận tam giác trên:* Nếu $A=(a_(i j))$, $B=(b_(i j))$ tam giác trên thì với $i>j$,
  $
    (A B)_(i j)=sum_(k=1)^n a_(i k)b_(k j)=0,
  $
  vì muốn một hạng tử khác $0$ thì cần $i <=k<=j$, điều không thể. Tổng của hai ma trận tam giác trên vẫn tam giác trên.
- *Ma trận tam giác dưới:* Lập luận tương tự: nếu $i<j$ thì các hạng tử trong $(A B)_(i j)$ đều bằng $0$. Tổng vẫn tam giác dưới.
- *Ma trận tam giác trên ngặt:* Nếu $A,B$ tam giác trên ngặt, tại vị trí $i>=j$, muốn $a_(i k)b_(k j) !=0$ thì phải đồng thời có $i<k$ và $k<j$, tức $i<k<j$, vô lý. Do đó $A B$ vẫn tam giác trên ngặt; tổng cũng vậy.
- *Ma trận tam giác dưới ngặt:* Tương tự, tại vị trí $i<=j$, muốn $a_(i k)b_(k j) !=0$ thì cần $i>k>j$, vô lý. Do đó tích và tổng vẫn thuộc tập đang xét.

Đối với cả năm tập, ma trận không thuộc tập, và nếu $A$ thuộc tập thì $-A$ cùng loại. Phép cộng giao hoán, kết hợp vì kế thừa từ phép cộng ma trận. Vì thế *mỗi tập đều là nhóm Abel đối với phép cộng*.

*2. Phép nhân kết hợp và hai luật phân phối.* Vì cả năm tập đều đóng đối với tích ma trận, các đẳng thức
$
  (A B)C=A(B C),
$
$
  A(B+C)=A B+A C,
$
$
  (A+B)C=A C+B C
$
đều đúng do kế thừa từ đại số ma trận $M_n(F)$. Vậy *cả năm tập đều là vành nếu cho phép vành không có đơn vị*.

*3. Đơn vị, tính giao hoán và ước của không.*

- *Ma trận chéo:* Có đơn vị $I_n$, và mọi cặp ma trận chéo giao hoán. Tuy nhiên $E_(1 1)E_(2 2)=0$ với $E_(1 1),E_(2 2) !=0$. Do đó không là miền nguyên, không là trường.
- *Ma trận tam giác trên:* Có đơn vị $I_n$. Phép nhân nói chung không giao hoán, vì $E_(1 1)E_(1 2)=E_(1 2)$ trong khi $E_(1 2)E_(1 1)=0$. Ngoài ra $E_(1 1)E_(2 2)=0$ với hai thừa số khác không. Do đó không là miền nguyên, không là trường.
- *Ma trận tam giác dưới:* Có đơn vị $I_n$. Phép nhân không giao hoán vì $E_(2 2)E_(2 1)=E_(2 1)$ nhưng $E_(2 1)E_(2 2)=0$. Lại có $E_(1 1)E_(2 2)=0$. Do đó không là miền nguyên, không là trường.
- *Ma trận tam giác trên ngặt:* Không chứa $I_n$. Thực tế không tồn tại bất kỳ đơn vị nhân nào: với mọi ma trận $U$ tam giác trên ngặt, cột thứ nhất của $U$ bằng $0$, nên $U E_(1 2)=0 !=E_(1 2)$. Đồng thời $E_(1 2)^2=0$ với $E_(1 2) !=0$. Vậy có ước của không và không là trường.
- *Ma trận tam giác dưới ngặt:* Không có đơn vị nhân: với mọi $L$ tam giác dưới ngặt, cột thứ $n$ của $L$ bằng $0$, nên $L E_(n,n-1)=0 !=E_(n,n-1)$. Ngoài ra $E_(2 1)^2=0$ với $E_(2 1) !=0$. Vậy có ước của không và không là trường.

Đối với hai loại tam giác ngặt: khi $n=2$ thì tích của hai ma trận bất kỳ đều bằng ma trận không, nên phép nhân giao hoán; khi $n>=3$ thì không giao hoán, chẳng hạn $E_(1 2)E_(2 3)=E_(1 3)$ nhưng $E_(2 3)E_(1 2)=0$ trong trường hợp tam giác trên ngặt (trường hợp dưới ngặt tương tự).

*Kết luận:* Ba loại chéo, tam giác trên, tam giác dưới là vành có đơn vị, nhưng không là miền nguyên hay trường. Hai loại tam giác ngặt là vành không có đơn vị nếu chấp nhận định nghĩa vành không bắt buộc có đơn vị; nếu định nghĩa vành bắt buộc có $1$ thì hai loại này *không là vành theo quy ước đó*.

*Câu 10.*

Đặt
$
  N(a,b)=mat(a,b;6 b,a), quad \
  F={N(a,b) | a,b in QQ}.
$

*1. Tính đóng.* Với $a,b,c,d in QQ$,
$
  N(a,b)+N(c,d)=N(a+c,b+d) in F,
$
$
  N(a,b)N(c,d)=N(a c+6 b d,a d+b c) in F.
$

*2. Kiểm tra phép cộng.* Phép cộng kết hợp, giao hoán do kế thừa từ phép cộng ma trận; ma trận không là $N(0,0)$ và phần tử đối của $N(a,b)$ là $N(-a,-b)$. Vậy $(F,+)$ là nhóm Abel.

*3. Kiểm tra phép nhân và phân phối.* Phép nhân kết hợp và phân phối do tính đóng và các tính chất của tích ma trận. Theo công thức tích, $N(a,b)N(c,d)=N(c,d)N(a,b)$, nên phép nhân giao hoán. Đơn vị là $N(1,0)=I_2 in F$. Vì vậy $F$ là *vành giao hoán có đơn vị*.

*4. Kiểm tra nghịch đảo.* Cho $A=N(a,b) !=0$, tức $(a,b)!=(0,0)$. Ta có
$
  det A=a^2-6 b^2.
$
Nếu $a^2-6 b^2=0$ và $b !=0$, thì $(a/b)^2=6$, vô lý vì $sqrt(6) in.not QQ$. Nếu $b=0$ thì $a=0$, cũng trái với $A !=0$. Do đó $a^2-6 b^2 !=0$.

Đặt
$
  B=N(frac(a,a^2-6 b^2),frac(-b,a^2-6 b^2)) in F.
$
Khi đó
$
  A B
  &=N(frac(a^2-6 b^2,a^2-6 b^2),frac(-a b+a b,a^2-6 b^2)) \
  &=N(1,0)=I_2.
$
Vì phép nhân giao hoán nên $B A=I_2$; mọi phần tử khác không đều khả nghịch.

*Kết luận:* $F$ là *trường*, do đó cũng là miền nguyên và vành.

*Câu 11.*

Đặt
$
  (x,y)+(z,t)=(x+z,y+t),
$
$
  (x,y)(z,t)=(x z-y t,x t+y z).
$

*1. Tính đóng.* Nếu $x,y,z,t in RR$ thì $x+z$, $y+t$, $x z-y t$, $x t+y z$ đều thuộc $RR$. Vậy hai phép toán đóng trên $RR^2$.

*2. Kiểm tra phép cộng.* Với mọi $u=(x,y)$, $v=(z,t)$, $w=(r,s)$,

- *Giao hoán:* $u+v=(x+z,y+t)=(z+x,t+y)=v+u$.
- *Kết hợp:* $(u+v)+w=(x+z+r,y+t+s)=u+(v+w)$.
- *Phần tử không:* $0_C=(0,0)$, vì $u+(0,0)=u$.
- *Phần tử đối:* $-u=(-x,-y)$, vì $u+(-u)=(0,0)$.

Vậy $(C,+)$ là nhóm Abel.

*3. Kiểm tra phép nhân.*

- *Giao hoán:* $u v=(x z-y t,x t+y z)=(z x-t y,z y+t x)=v u$.
- *Kết hợp:* Đặt $w=(r,s)$. Ta có
  $
    (u v)w
    &=(x z r-y t r-x t s-y z s, \
    &quad x z s-y t s+x t r+y z r),
  $
  còn
  $
    u(v w)
    &=(x z r-x t s-y z s-y t r, \
    &quad x z s+x t r+y z r-y t s).
  $
  Hai tọa độ tương ứng bằng nhau do phép cộng, nhân thực có tính giao hoán và kết hợp. Do đó $(u v)w=u(v w)$.
- *Đơn vị:* $1_C=(1,0)$, vì $(x,y)(1,0)=(x,y)$.
- *Phần tử không hấp thụ:* $(x,y)(0,0)=(0,0)$.

*4. Kiểm tra hai luật phân phối.* Với $v=(z,t)$ và $w=(r,s)$,
$
  u(v+w)
  &=(x(z+r)-y(t+s),x(t+s)+y(z+r)) \
  &=(x z-y t+x r-y s,x t+y z+x s+y r) \
  &=u v+u w.
$
Do phép nhân giao hoán, $(u+v)w=u w+v w$ cũng đúng. Vậy $C$ là *vành giao hoán có đơn vị*.

*5. Kiểm tra nghịch đảo.* Lấy $(x,y) !=(0,0)$. Khi đó $x^2+y^2>0$. Xét
$
  (z,t)=(frac(x,x^2+y^2),frac(-y,x^2+y^2)) in C.
$
Ta có
$
  (x,y)(z,t)
  &=(frac(x^2+y^2,x^2+y^2),frac(-x y+y x,x^2+y^2)) \
  &=(1,0)=1_C.
$
Do đó mọi phần tử khác không đều có nghịch đảo.

*Kết luận:* $C$ là *trường*, do đó là miền nguyên và vành.
]


// Bài 2.2
#baitoan[
Giả sử vành $R$ có duy nhất một phần tử đơn vị trái. Chứng minh $R$ có đơn vị.
]
#loigiai[

  Giả sử vành $R$ có duy nhất một phần tử đơn vị trái, ta đặt $e$ là phần tử đơn vị trái của $R$. Khi đó, $forall x in R,e x=x$. Ta chứng minh $e$ cũng là đơn vị phải của $R$ và do đó $R$ có đơn vị.

  Thật vậy, điều cần chứng minh : $forall x in R, x e = x $, do đó lấy $x in R$, ta đặt $u= x e - x$, khi đó nhân 2 vế cho $y in R$, ta được $u y = (x e - x) y= x e y - x y=x (e y)- x y= x y - x y =0$.Vậy, ta luôn có $forall y in R, u y=0$. Khi đó, với tùy ý $x in R$, có $(e +u) x=e x + u x$ mà $u x =0,forall x in R$, nên $(e+u) x= e x = x$. Vậy $(e+u)$ là một phần tử đơn vị trái, do $R$ có duy nhất một phần tử đơn vị trái, nên $e+u=e => (-e)+e+u=(-e)+e=0 => u=0$. Vậy, $x e- x=0 <=> x e =x$. Hay $e$ là phần tử đơn vị phải, nên do đó $R$ có đơn vị.
]
// Bài 2.3
#baitoan[
Giải các phương trình:

a) $21 overline(x) + overline(24) = overline(101)$ trong $ZZ_103$.

b) $68 (overline(x) + overline(24)) = overline(102)$ trong $ZZ_492$.

c) $78 overline(x) - overline(13) = overline(35)$ trong $ZZ_666$.
]
#loigiai[

  *a)* Xét phương trình $ 21 overline(x) + overline(24)=overline(101) quad "Trong "ZZ_(103) quad(1) $.

  Khi đó, có $(1)$ tương đương $21 overline(x)=overline(77)$. Mặt khác, do $gcd(21,103)=1$, nên $(1)$ có đúng một nghiệm duy nhất , hơn nữa dễ dàng kiểm chứng thấy nghịch đảo của $overline(21)$ trong $ZZ_(103)=overline(-49)=overline(54)$. Do đó, nghiệm của phương trình trên là $overline(x)= overline(54 .77)=overline(4158)=overline(38)$.
  
]
// Bài 2.4
#baitoan[
Tìm tất cả các số nguyên $n$ thỏa điều kiện trong mỗi trường hợp sau:

a) $27 n - 18$ chia hết cho $133$.

b) $92 n + 18$ chia hết cho $100$.

c) $95 n - 15$ chia hết cho $335$.
]

// Bài 2.5
#baitoan[
Cho $R$ là một vành có tính chất sau:
$ x^2 = x quad "với mọi" x in R. $
(Ta gọi $R$ là *vành Bool*). Chứng minh rằng:

a) $x = -x$ với mọi $x in R$.

b) $R$ là vành giao hoán.

c) Nếu $R$ là vành không có ước của $0$ và $R$ có nhiều hơn một phần tử thì $R$ là miền nguyên.
]
#loigiai[

  *a)* Ta chứng minh , $forall x in R$, $x=-x$. Thật vậy, xét $(x+x) in R$, khi đó có $(x+x)^2=x+x$, hơn nữa có $(x+x)^2=(x+x)(x+x)=x^2+x^2+x^2+x^2=4x^2=4 x=x+x+x+x=x+x => x+x=0 => x=-x forall x in R$.

  *b)* Lấy tùy ý $x,y in R$, ta chứng minh $x y= y x$. Thật vậy, với $x,y in R$, thì $(x+y) in R$, do đó có $(x+y)^2=(x+y)(x+y)=x^2+x y + y x +y^2=x +y <=> x+ x y + y x + y= x +y <=> x  y= - y x$, do câu $a)$ , nên suy ra $-y x = y x$, vậy $x y = y x$.

  *c)* Ta chứng minh $R$ có phần tử đơn vị. Thật vậy, do $R$ có nhiều hơn một phần tử, nên có $e in R$, sao cho $e!=0$. Ta sẽ chứng minh $e$ là phần tử đơn vị của $R$.

  $forall x in R$, ta có $e (e x -x)=e ^2 x - e x = e x - e x =0$. Do đó, với $e !=0$, thì $ e x - x =0 <=> e x = x =x e quad "Do R giao hoán"$. Vậy, $R$ có phần tử đơn vị và kết hợp với điều kiện của ý trên, $R$ là miền nguyên.
]

// Bài 2.6
#baitoan[
\* Cho $R$ là một vành có tính chất sau:
$ x^3 = x quad "với mọi" x in R. $
Chứng minh rằng $R$ là một vành giao hoán.
]
#loigiai[
  Lấy $x, y in R$ tùy ý. Ta cần chứng minh
$
  x y = y x.
$

Điều này tương đương với
$
  x y - y x = 0.
$

Theo giả thiết, vì $x y - y x in R$, nên
$
  (x y - y x)^3 = x y - y x.
$

Như vậy, nếu chứng minh được
$
  (x y - y x)^2 = 0,
$
thì
$
  x y - y x
  &= (x y - y x)^3 \
  &= (x y - y x)^2 (x y - y x) \
  &= 0.
$

Do đó, ta chỉ cần chứng minh $(x y - y x)^2 = 0$.

Ta có
$
  (x y - y x)^2
  &= x y x y - x y^2 x - y x^2 y + y x y x \
  &= (x y x y - x y^2 x)
     + (y x y x - y x^2 y).
$

Nhận thấy hai biểu thức trong ngoặc có cùng dạng khi đổi vai trò $x$ và $y$.

Vì vậy, ta chỉ cần chứng minh
$
  x y x y = x y^2 x. " (1)"
$

Khi đó, đổi vai trò $x$ và $y$, ta cũng được
$
  y x y x = y x^2 y.
$

*1. Xét đẳng thức cần chứng minh*

Từ (1), ta có
$
  x y x y = x y^2 x
  &<=> x y x y - x y^2 x = 0 \
  &<=> x y (x y - y x) = 0.
$

Ta chưa thể suy ra trực tiếp tích trên bằng $0$. Vì vậy, ta khai thác giả thiết $(x y)^3 = x y$.

Nhân hai vế bên phải với $y x$, ta được
$
  (x y)^3 (y x) = (x y)(y x).
$

Suy ra
$
  x y^2 x
  &= (x y)(y x) \
  &= (x y)^3(y x) \
  &= (x y)^2((x y)(y x)) \
  &= (x y)^2(x y^2 x).
$

Hay
$
  x y^2 x = (x y)((x y)(x y^2 x)). " (2)"
$

Để vế phải của (2) trở thành $(x y)(x y) = x y x y$, ta cần chứng minh
$
  (x y)(x y^2 x) = x y. " (3)"
$

*2. Xét đẳng thức (3)*

Ta khai triển
$
  (x y)(x y^2 x) = x y x y^2 x.
$

Từ giả thiết $x^3 = x$ và $y^3 = y$, ta muốn biến đổi biểu thức trên để xuất hiện các tích $x^3$ và $y^3$.

Nếu chứng minh được
$
  y^2 x = x y^2,
$
thì
$
  x y x y^2 x
  &= x y x (y^2 x) \
  &= x y x (x y^2) \
  &= x y x^2 y^2.
$

Tiếp tục, nếu chứng minh được
$
  y x^2 = x^2 y,
$
thì
$
  x y x^2 y^2
  &= x (y x^2)y^2 \
  &= x (x^2 y)y^2 \
  &= x^3 y^3 \
  &= x y.
$

Vậy để chứng minh (3), ta chỉ cần chứng minh hai đẳng thức
$
  x^2 y = y x^2, quad
  y^2 x = x y^2.
$

Do $x,y$ tùy ý, hai đẳng thức này có cùng dạng. Vì vậy, ta chỉ cần chứng minh
$
  x^2 y = y x^2. " (4)"
$

*3. Chứng minh đẳng thức (4)*

Ta cần chứng minh
$
  x^2 y - y x^2 = 0.
$

Theo giả thiết
$
  x^3 = x.
$

Nhân hai vế với $x$, ta được
$
  x^4 = x^2.
$

Từ đó
$
  x^4 - x^2 = 0.
$

Ta tìm cách sử dụng đẳng thức này để biến đổi hiệu $x^2 y - y x^2$.

Nhận thấy $x^2$ nằm bên trái $y$ trong số hạng thứ nhất, nhưng nằm bên phải $y$ trong số hạng thứ hai.

Ta thử đưa cả hai số hạng về một biểu thức trung gian có $x^2$ ở cả hai phía của $y$, tức là $x^2 y x^2$.

Lý do chọn biểu thức này là khi nhân thêm $x^2$ vào các hiệu
$
  x^2 y - x^2 y x^2
$
và
$
  x^2 y x^2 - y x^2,
$
ta có thể tạo ra các số hạng chứa $x^4 - x^2 = 0$.

Do đó, ta viết
$
  x^2 y - y x^2
  &= x^2 y - x^2 y x^2
     + x^2 y x^2 - y x^2 \
  &= (x^2 y - x^2 y x^2)
     + (x^2 y x^2 - y x^2).
$

Trước hết, xét biểu thức thứ nhất.

Ta có
$
  (x^2 y - x^2 y x^2)^2
  &= (x^2 y - x^2 y x^2)
     (x^2 y - x^2 y x^2) \
  &= (x^2 y - x^2 y x^2)
     x^2 (y - y x^2) \
  &= (x^2 y x^2 - x^2 y x^4)
     (y - y x^2) \
  &= (x^2 y x^2 - x^2 y x^2)
     (y - y x^2) \
  &= 0.
$

Đặt $a = x^2 y - x^2 y x^2$.

Vì $a in R$, theo giả thiết $a^3 = a$, nên
$
  a = a^3 = a^2 a = 0.
$

Suy ra
$
  x^2 y = x^2 y x^2. " (5)"
$

Tiếp tục, xét biểu thức thứ hai.

Ta có
$
  (x^2 y x^2 - y x^2)^2
  &= (x^2 y x^2 - y x^2)
     (x^2 y x^2 - y x^2) \
  &= (x^2 y - y)x^2
     (x^2 y x^2 - y x^2) \
  &= (x^2 y - y)
     (x^4 y x^2 - x^2 y x^2) \
  &= (x^2 y - y)
     (x^2 y x^2 - x^2 y x^2) \
  &= 0.
$

Đặt $b = x^2 y x^2 - y x^2$.

Vì $b in R$, theo giả thiết $b^3 = b$, nên
$
  b = b^3 = b^2 b = 0.
$

Suy ra
$
  x^2 y x^2 = y x^2. " (6)"
$

Từ (5) và (6), ta được
$
  x^2 y = x^2 y x^2 = y x^2.
$

Vậy
$
  x^2 y = y x^2. " (7)"
$

Do $x,y in R$ tùy ý, đổi vai trò $x$ và $y$, ta cũng được
$
  y^2 x = x y^2. " (8)"
$

*4. Quay trở lại chứng minh đẳng thức (3)*

Ta cần chứng minh
$
  (x y)(x y^2 x) = x y.
$

Sử dụng (7) và (8), ta có
$
  (x y)(x y^2 x)
  &= (x y)(x (y^2 x)) \
  &= (x y)(x (x y^2)) \
  &= (x y)(x^2 y^2) \
  &= x y x^2 y^2 \
  &= x (y x^2)y^2 \
  &= x (x^2 y)y^2 \
  &= x^3 y^3 \
  &= x y.
$

Vậy
$
  (x y)(x y^2 x) = x y.
$

*5. Quay trở lại chứng minh đẳng thức (1)*

Theo (2), ta có
$
  x y^2 x
  &= (x y)((x y)(x y^2 x)) \
  &= (x y)(x y) \
  &= x y x y.
$

Suy ra
$
  x y x y = x y^2 x. " (9)"
$

Vì $x,y in R$ tùy ý, đổi vai trò $x$ và $y$, ta cũng được
$
  y x y x = y x^2 y. " (10)"
$

*6. Kết luận*

Từ (9) và (10), ta có
$
  (x y - y x)^2
  &= x y x y - x y^2 x - y x^2 y + y x y x \
  &= (x y x y - x y^2 x)
     + (y x y x - y x^2 y) \
  &= 0.
$

Mặt khác, vì $x y - y x in R$, theo giả thiết
$
  x y - y x
  &= (x y - y x)^3 \
  &= (x y - y x)^2(x y - y x) \
  &= 0.
$

Suy ra
$
  x y = y x, quad forall x,y in R.
$

Vậy $R$ là vành giao hoán. $square$
]

// Bài 2.7
#baitoan[
Cho $R$ là một vành tùy ý.

a) Với $a in R$, tập hợp $C(a) = {x in R | a x = x a}$ được gọi là *tâm hóa tử* của $a$. Chứng minh rằng $C(a)$ là một vành con của $R$ có chứa $a$.

b) Tập hợp $C(R) = {x in R | a x = x a, forall a in R}$ được gọi là *tâm* của $R$. Chứng minh rằng $C(R)$ là một vành con giao hoán của $R$.

c) Tìm tâm của vành $M(n, RR)$.
]
#loigiai[

  *a)* Ta chứng minh, $C(a)$ là vành con của $R$.

  Với $0 in RR$, ta luôn có $forall x in RR, x 0= 0x =0=> C(a)!=emptyset$. Hơn nữa, lấy tùy ý $x,y in C(a) => a x = x a ; a y= y a$.Ta chứng minh $ x+y in A $ Vì $R$ là vành , nên ta có
  $
  a(x-y)=a x -a y = x a -y a=(x-y) a => x-y in C(a)
  $
  Hơn nữa, lấy $
  x,y in C(a) "có" a(x y)=(a x) y=(x a)y=x(a y)=(x y) a => x y in C(a).
  $
  Vậy, $C(a)$ là vành con của $R$, mặt khác xét $x=a in R$, ta thu được $a^2=a^2 => a in C(a)$.

  *b)* 
  Có $0 in C(R)$, vì với bất kỳ $a in R, 0 a = a 0 =0 => C(R)!= emptyset$.

  Lấy $x,y in C(R)$, khi đó với bất kỳ $a in R$, thì $a x= x a, a y= y a$. Cho trước $b in R$ bất kỳ, ta chứng minh $x-y in C(b)$. Từ giả thiết $x,y in C(R)$, khi đó xét $a= b$, ta thu được
  $
  b(x-y)=b x - b y=x b - y b=(x-y) b=> x- y in C(b)
  $
  Vì $b$ tùy ý $in R$, do đó $x-y in C(b)$. Mặt khác, cho trước $b in R$, ta chứng minh
  $
  b(x y)= (x y) b " tương tự xét" a=b => a (x y)= (a x) y=(x a) y=(x y) a=> x y in C(b)
  $
  Do đó, $x y in C(R)$. Vậy $C(R)$ là vành con của $R$.

  Lấy bất kỳ $x,y in C(R)$ ta chứng minh $x y = y x$.Vì $x, y in C(R)$, nên với bất kỳ $a in R$, ta đều có $a x = x a; a y = y a$. Khi đó, vì điều trên đúng với bất kỳ $a in R$, ta xét $a=y$ thì có điều phải chứng minh.

  *c)*
  Với vành $M(n,RR)$. Khi đó, $C(M)={A in M : A B = B A , forall B in M}$.
  
  
]
// Bài 2.8
#baitoan[
Cho $R$ là một vành có đơn vị $e$ và $x, y in R$. Chứng minh rằng nếu $u = e + x y$ khả nghịch thì $e + y x$ cũng khả nghịch và
$ (e + y x)^(-1) = e - y u^(-1) x. $
]

// Bài 2.9
#baitoan[
Cho $R$ là một vành có đơn vị $e$. Chứng minh rằng với $I$ là một ideal của $R$ ta có $I = R$ khi và chỉ khi $I$ chứa đơn vị $e$. Kết quả trên còn đúng cho các ideal trái, ideal phải hay các vành con của $R$ hay không?
]

#loigiai[

  Xét $R$ là một vành có đơn vị $e$, giả sử $I$ là một ideal của $R$ và $I=R$, ta chứng minh $e in I$. Thật vậy, có $e in R => e in I$.

  *(<=)* Giả sử $e in I$, ta chứng minh $I= R$. Cho trước $x in I$, vì $I subset R => x in R$. Do đó, $I subset.eq R$. Mặt khác, cho trước $x in R$, ta chứng minh $x in I$. Mặt khác, với $e in I$, ta có $x e = x$, mà $I$ là ideal nên $x e = x in I => x in I$. Vậy, $R subset.eq I => I=R$. Đối với ideal trái, ideal phải chứng minh tương tự như trên, nhưng với vành con thì không đúng.Xét vành $QQ$ và vành con $ZZ$, khi đó $ZZ$ chứa đơn vị $1$ nhưng $ZZ subset.not QQ$.  
]
// Bài 2.10
#baitoan[
Cho $R$ là một vành tùy ý, $I$ và $J$ là hai ideal của $R$. Đặt
$ I + J = {x + y | x in I, y in J}. $
Chứng minh rằng $I + J$ là một ideal của $R$. Nếu $R$ là vành các số nguyên và $I = m ZZ$; $J = n ZZ$ thì $I + J$ có dạng thế nào?
]
#loigiai[

  Ta chứng minh $I+J$ là một ideal của $R$.

  Ta chứng minh $I+J$ là vành con, thật vậy với $I,J$ là hai ideal của $R$, nên ta có $0 in I$ và $0 in R => 0+0=0 in (I+J)$. Do đó, $I+J != emptyset$.

  Lấy tùy ý $x,y in I+J => exists a,c in I "và ",b,d in J : x=a+b "và" y=c+d$. Do đó, $
  x-y=(a+b)-(c+d)=(a-c)+(b-d) quad "vì I,J là ideal nên đặc biệt là vành con" => (a-c in I);(b-d) in J => (x-y) in (Ị+J)
  $
  Hơn nữa, lấy tùy ý $x,y in I+J$ lập luận tương tự trên, ta thu được
  $
  x y=(a+b)(c+d)=a c+a d+b c+b d=(a c + a d)+(b c+b d)
  $
  Vì $I$ là ideal, nên xét $d in R => a d in I$, tương tự , ta có $b c in J$ vì $J$ là ideal. Do đó,
  $
  x y=(a c+ a d) +(b c + b d)in (I+J)
  $
  Vậy,$(I+J)$ là vành con của $R$.

  Ta chứng minh $(I+J)$ là ideal của $R$. Cho trước $ r in R $ và lấy $x in (I+J)$ tùy ý, ta chứng minh $r x in (I+J)$. Vì $ x in (I+J) => exists a in I, b in J : x= a+b $ Khi đó, $r x =r(a+b)=r a + r b$. Mặt khác, vì $I,J$ là hai ideal, nên $r a in I$ và $r b in J => r x in (I+J)$. Vậy $(I+J)$ là ideal trái.

  Cho trước $r in R$ và lấy $x in (I+J)$ tùy ý, ta chứng minh $x r in (I+J)$. Lập luận tương tự, ta có $x r =(a+b) r = a r + b r in (I+J) "vì I,J là hai ideal"$. Vậy ta có điều phải chứng minh.
  
]
// Bài 2.11
#baitoan[
Cho $R$ là một vành tùy ý, $I$ và $J$ là hai ideal của $R$. Đặt
$ I J = {sum_(i=1)^n x_i y_i | n in NN, x_i in I, y_i in J}. $
Chứng minh rằng $I J$ là một ideal của $R$. Nếu $R$ là vành các số nguyên và $I = m ZZ$; $J = n ZZ$ thì $I J$ có dạng thế nào?
]
#loigiai[

  Ta chứng minh $I J$ là vành con của $R$.

  Có $0_R in I J$, vì $0_R = sum_(i=1)^n 0. 0$, do đó $I J$ khác rỗng.

  Lấy $x,y in I J$. Khi đó, $x= sum_(i=1)^n k_i m_i : k_i in I ; m_i in J$. Ta chứng minh $x-y in I J$. Ta có,
  $
  x-y=sum_(i=1)^n k_i m_i-sum_(i=1)^n u_i v_i=sum_(i=1)^n k_i m_i +sum_(i=1)^n-(u_i) m_i
  $
  Vì $u_i in I => -u_i in I "vì I là ideal nên đặc biệt là vành con"$. Do đó, $x-y in I J$.

  Mặt khác, có
]
// Bài 2.12
#baitoan[
Cho $R$ là một vành tùy ý và $n$ là một số nguyên cho trước. Chứng minh rằng tập hợp
$ I = {x in R | n x = 0} $
là một ideal của $R$.
]

// Bài 2.13
#baitoan[
Cho $R$ là một vành tùy ý và $a in R$. Chứng minh rằng tập hợp
$ a R = {a x | x in R} $
là một ideal phải của $R$, và tập hợp
$ R a = {x a | x in R} $
là một ideal trái của $R$. Suy ra nếu $R$ giao hoán thì $a R = R a$ là ideal của $R$; hơn nữa, nếu giả thiết thêm $R$ có đơn vị thì đây chính là ideal chính sinh bởi $a$.
]

// Bài 2.14
#baitoan[
Cho $R$ là một vành có đơn vị và $a in R$. Chứng minh rằng:

a) $a$ khả nghịch phải khi và chỉ khi $a R = R$.

b) $a$ khả nghịch trái khi và chỉ khi $R a = R$.

c) $a$ khả nghịch khi và chỉ khi $a R = R a = R$.
]
#loigiai[

  *a)* *=>* Giả sử $a$ khả nghịch phải, khi đó có $b in R$ sao cho $a b=1$. Mặt khác, luôn có $a R subset R$, vì $R$ đóng với phép toán nhân. Hơn nữa, với bất kỳ $y in R$, đều có $y=1.y=a b y=a (b y) in a R$. Suy ra, $R subset.eq a R$. Do đó, $a R=R$.

  *<=)* Giả sử $R=a R$, khi đó ta chứng minh $a$ khả nghịch phải, thật vậy, vì $a R=R$, suy ra có
]

// Bài 2.15
#baitoan[
a) Cho $R$ là một vành giao hoán và $a in R$. Chứng minh rằng tập hợp con
$ "Ann"(a) = {x in R | a x = 0} $
là một ideal của $R$.

b) Tìm $"Ann"(overline(4))$ trong vành $ZZ_32$.
]

// Bài 2.16
#baitoan[
Cho $R$ là một vành tùy ý. Một phần tử $x in R$ được gọi là *lũy linh* nếu tồn tại một số $n$ nguyên dương sao cho $x^n = 0$.

a) Chứng minh rằng nếu $R$ có đơn vị là $e$ và $x$ lũy linh thì $e + x$ khả nghịch.

b) Giả sử $R$ giao hoán, có đơn vị và $u in R$ khả nghịch. Chứng minh rằng nếu $x$ lũy linh thì $u + x$ khả nghịch.

c) Giả sử $R$ giao hoán. Chứng minh rằng tập hợp $N(R)$ gồm tất cả các phần tử lũy linh của $R$ là một ideal của $R$ và trong vành thương $R \/ N(R)$ không có phần tử lũy linh nào khác không (ta gọi $N(R)$ là *nil-căn* của $R$).
]

// Bài 2.17
#baitoan[
Xét $R$ là một vành tùy ý và $ZZ$ là vành các số nguyên. Trên tích Descartes $R times ZZ$ ta định nghĩa các phép toán như sau:
$ (x,m) + (y,n) = (x+y, m+n); $
$ (x,m)(y,n) = (x y + m y + n x, m n). $

a) Chứng minh rằng $R times ZZ$ là một vành có đơn vị.

b) Chứng minh rằng ánh xạ $f: x -> (x,0)$ là một đơn cấu.

(Do các kết quả trên người ta nói rằng bao giờ cũng có thể nhúng một vành tùy ý vào một vành có đơn vị).
]

// Bài 2.18
#baitoan[
a) Chứng minh rằng mọi vành có đơn vị và có đúng $p$ phần tử với $p$ nguyên tố, đều đẳng cấu với vành $ZZ_p$.

b) Khẳng định “Mọi vành có đơn vị và có đúng $m$ phần tử với $m$ nguyên dương đều đẳng cấu với $ZZ_m$” có đúng hay không?
]

// Bài 2.19
#baitoan[
Cho $f$ là một tự đồng cấu của vành $R$. Chứng minh rằng tập hợp
$ I = {x in R | f(x) = x} $
là một vành con của $R$.
]

// Bài 2.20
#baitoan[
Cho $R, S$ là hai vành. Xét tích Descartes $T = R times S$ và các tập con $overline(R) = R times {0}$ và $overline(S) = {0} times S$. Trên $T$ ta định nghĩa các phép toán như sau:
$ (x,y) + (z,t) = (x+z, y+t); $
$ (x,y)(z,t) = (x z, y t). $
Chứng minh rằng:

a) $T$ là một vành.

b) $overline(R)$ và $overline(S)$ lần lượt là các ideal của $T$ đẳng cấu với $R$ và $S$.

c) $overline(R)$ và $overline(S)$ là các ideal của $T$ thỏa $overline(R) inter overline(S) = {(0,0)}$ và $overline(R) + overline(S) = T$.

d) Giả sử $R, S$ là các vành có đơn vị. Hãy tìm các đơn vị của $T$, $overline(R)$ và $overline(S)$.
]

// Bài 2.21
#baitoan[
Cho $R$ là một vành và $a in R$. Chứng minh rằng:

a) Tập hợp $E$ gồm tất cả các tự đồng cấu của nhóm cộng Abel $R$ với các phép toán định bởi: Với mọi $f,g in E$,
$ (f+g)(x) = f(x)+g(x) quad "và" quad (f g)(x) = f(g(x)), quad forall x in R $
là một vành.

b) Ánh xạ $h_a: x -> a x$ là một tự đồng cấu của nhóm cộng Abel $R$.

c) Ánh xạ $h: b -> h_b$ là một đồng cấu vành từ $R$ đến $E$.

d) Tìm $"Ker" h$. Chứng tỏ $h$ là đơn cấu nếu $R$ có đơn vị.
]

// Bài 2.22
#baitoan[
Cho $R$ là một miền nguyên và $n$ là cấp (trong nhóm $(R,+)$) của phần tử đơn vị $e$. Chứng minh rằng:

a) $n$ là một số nguyên tố.

b) Mọi phần tử khác không của $R$ đều có cấp $n$.

c) Với mỗi số nguyên $m$ cho trước, tập hợp
$ m R = {m x | x in R} $
là một ideal của $R$ thỏa
$ R \/ m R tilde.eq cases(R & "nếu" m "là bội số của" n, {0} & "nếu" m "không là bội số của" n). $
]

// Bài 2.23
#baitoan[
Trong trường các số phức $CC$ xét
$ QQ(sqrt(2)) = {a+b sqrt(2) | a,b in QQ} quad "và" quad QQ(i) = {a+b i | a,b in QQ}. $

a) Chứng minh rằng $QQ(sqrt(2))$ và $QQ(i)$ là các trường con của $CC$.

b) Chứng minh rằng $QQ(sqrt(2))$ và $QQ(i)$ không đẳng cấu.

c) Tìm tất cả các trường con của $QQ(sqrt(2))$; của $QQ(i)$.

d)\* Chứng minh rằng tập hợp $A = {a + b root(3,2) + c root(3,4) | a,b,c in QQ}$ là một trường con của $CC$.
]

// Bài 2.24
#baitoan[
Chứng minh rằng:

a) $K = {mat(a,b; -b,a) | a,b in QQ}$ là một trường đẳng cấu với $QQ(i)$.

b) $F = {mat(a,b; 2 b,a) | a,b in QQ}$ là một trường đẳng cấu với $QQ(sqrt(2))$.
]

// Bài 2.25
#baitoan[
Cho $n$ là một số nguyên dương. Chứng minh rằng các khẳng định sau tương đương:

a) $ZZ_n$ là một miền nguyên;

b) $ZZ_n$ là một trường;

c) $n$ là một số nguyên tố.
]

// Bài 2.26
#baitoan[
Cho $R$ là một vành giao hoán có đơn vị; $I$ là một ideal của $R$ và $I$ khác $R$. Ta nói:

i) $I$ là *ideal tối đại* của $R$ nếu chỉ có hai ideal chứa $I$ là $I$ và $R$.

ii) $I$ là *ideal nguyên tố* của $R$ nếu tính chất sau được thỏa: Với mọi $x,y in R$, nếu $x y in I$ thì $x in I$ hay $y in I$.

Chứng minh rằng:

a) $R \/ I$ là miền nguyên khi và chỉ khi $I$ là ideal nguyên tố.

b) $R \/ I$ là trường khi và chỉ khi $I$ là ideal tối đại.
]

// Bài 2.27
#baitoan[
Cho $R$ là một vành giao hoán có đơn vị và $R$ có hơn một phần tử. Chứng minh rằng các khẳng định sau tương đương:

a) $R$ là một trường;

b) $R$ chỉ có hai ideal là ${0}$ và $R$;

c) Mọi đồng cấu vành từ $R$ vào một vành bất kỳ hoặc là đồng cấu $0$ hoặc là đơn cấu.
]

// Bài 2.28
#baitoan[
Cho trường $F$ với phần tử đơn vị là $1$.

a) Chứng minh rằng với $x in F$, ta có $x^2=1$ khi và chỉ khi $x=plus.minus 1$.

b) Giả sử $F$ có đúng $p$ phần tử là $x_1, dots.h, x_(p-1)$ và $x_p=0$. Chứng minh rằng $x_1 dots.h.c x_(p-1)=-1$ và $forall x in F^*, x^(p-1)=1$.

c) Sử dụng kết quả b) để chứng minh rằng với mọi số nguyên tố dương $p$ ta có (Định lý Wilson)
$ (p-1)! equiv -1 quad ("mod" p) quad "và" quad k^p equiv k quad ("mod" p), quad forall k in ZZ. $
]

// Bài 2.29
#baitoan[
Cho $F$ là một trường với phần tử đơn vị $e$. Xét tập hợp
$ A = {n e | n in ZZ}. $
Chứng minh rằng:

a) $A$ là một vành con của $F$; hỏi $A$ có là miền nguyên không?

b) $A tilde.eq cases(ZZ & "nếu" e "có cấp vô hạn", ZZ_p & "nếu" e "có cấp" p).$

c) Nếu $e$ có cấp $p$ hữu hạn thì $A$ là một trường.
]

// Bài 2.30
#baitoan[
Chứng minh rằng trường các số hữu tỉ $QQ$ không có trường con nào khác ngoài $QQ$.
]

// Bài 2.31
#baitoan[
Chứng minh rằng mọi trường đều có trường con bé nhất (theo quan hệ bao hàm) đẳng cấu hoặc với trường số hữu tỉ hoặc với trường $ZZ_p$ với $p$ nguyên tố.
]

// Bài 2.32
#baitoan[
Cho $F$ là một trường và $A$ là một vành con của $F$.

a) Chứng minh rằng nếu $A$ có nhiều hơn một phần tử và $A$ có đơn vị thì phần tử đơn vị của $A$ trùng với phần tử đơn vị của $F$, và lúc đó $A$ là một miền nguyên.

b) Giả sử $A$ là một miền nguyên. Chứng minh rằng tập hợp
$ P = {a b^(-1) | a,b in A, b != 0} $
là một trường con của $F$ và $P$ là trường các thương của $A$.

c) Chứng minh rằng $P$ là trường con bé nhất trong các trường con của $F$ có chứa $A$.
]

// Bài 2.33
#baitoan[
Cho $p$ là một số nguyên tố. Chứng minh rằng tập hợp tất cả các số hữu tỉ có dạng $m/n$, trong đó $m,n$ là các số nguyên và $n$ nguyên tố cùng nhau với $p$, là một miền nguyên. Tìm trường các thương của miền nguyên này.
]

// Bài 2.34
#baitoan[
Xét hàm $phi$-Euler.

a) Chứng minh rằng $phi(p^alpha) = p^(alpha-1)(p-1)$ với mọi $p$ nguyên tố.

b) Xác định $phi(n)$ với $n in NN^*$.
]

// Bài 2.35
#baitoan[
Tìm tất cả các tự đồng cấu của các trường sau:

a) Trường các số hữu tỉ $QQ$.

b) Trường $QQ(sqrt(2))$.

c) Trường $QQ(i)$.

d) Trường các số thực $RR$.

e) Trường các số phức $CC$ sao cho các tự đồng cấu đó thu hẹp trên $RR$ là ánh xạ đồng nhất.
]

#pagebreak()
= Đề Thi Giữa Kỳ
== 2025-2026

#cau[
  *(5,0đ).* Cho $G = RR without {1}$ và phép toán $ast$ xác định bởi:

  $ x ast y = x + y - x y quad "với mọi" x, y in G. $

  a) Chứng minh $(G, ast)$ là nhóm.
  
  b) Tìm tất cả các phần tử có cấp hữu hạn trong nhóm $(G, ast)$.

  c) Cho $H = (-oo; 1)$. Chứng minh $H$ là nhóm con của $G$.

  d) Xét ánh xạ $phi: (G, ast) -> (RR without {0}, dot)$ xác định bởi

  $ phi(x) = 1 - x quad "với mọi" x in G. $

  Chứng minh rằng $phi$ là một đẳng cấu nhóm.
]

#cau[
  *(3,0đ).* Cho $sigma = (1 3 2 5)(2 7 6 4 3)(1 3 8 9 2) in S_9$.

  a) Phân tích $sigma$ và $sigma^(-1)$ thành tích của các chu trình rời nhau.

  b) Đếm số nghịch thế của $sigma$ và xác định tính chẵn-lẻ của $sigma$.

  c) Xác định cấp của $sigma$.
]

#cau[
  *(2,0đ).* Cho $G$ là nhóm có cấp $15$ và thỏa mãn điều kiện:

  $ a^7 b^8 = b^8 a^7 quad "với mọi" a, b in G. $

  Chứng minh rằng $G$ là nhóm aben.
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

  *a)* *Đóng* : Lấy $x,y in G$, ta chứng minh $x*y in G$. Thật vậy, có $x*y=x+y-x y =x(1-y)-(1-y)+1=(1-y )(x-1)+1$. Do đó, với $x,y in G$ thì $x,y !=1 => x*y !=1$ hay $x*y in G quad (1)$.

  *Kết Hợp* : Lấy $x,y,z in G$,có $(x*y)*z=(x*y)+z-(x*y) z=(x+y-x y)+z - (x+y- x y)z= x +y - x y+ z - x z + y z - x  y z=x*(y*z)=x+(y*z)-x(y*z). quad (2)$.

  *Giao Hoán* : Lấy $x,y in G$, có $x*y=x+y -x y=y +x - y x=y*x$, do đó $G$ giao hoán $(3)$.

  
  *Đơn vị* Tìm $e in G$, sao cho với bất kỳ $x in G$, thì $ x e = e x =x $ Xét $x*e=x+e-x e=x <=>e-x e=0 <=> e(1-x)=0$, vì $x in G$ nên $x!=0$, do đó $e=0$.

  Vậy chọn $e=0$ thì thỏa $e$ là đơn vị của $G$ do $
  x e=e x = x quad "Từ (3)". quad (4)
  $

  *Khả Nghịch* Lấy $x in G$, tìm $y in G$ sao cho $x*y= y* x = e$, thật vậy, có $
  x*y=x+y-x y=0 <=> (1-y)(x-1)=-1 <=>y=  1/(x-1)+1 in G , "Do x khác 1 thuộc G" quad (5)
  $

  Do đó, từ (1),(2),(3),(4),(5) thì $G$ là nhóm abel.

  *b)* Có $
  1-x*y=(1-y)(1-x) => 1-(x^(*m))=(1-x)^m
  $
  Do đó, $1-(1-x)^m=(x^(*m)) <=> (x^(*m)=e => 1=(1-x)^m => x=2 "m chẵn", x=0 "m lẻ"$. Do đó, các phần tử có cấp hữu hạn của $G$ là $x=0,x=2$.

  *c)* Dễ Thấy, $H subset G$, ta chứng minh $H<=G$. Có $e in H$, suy ra $H!=emptyset$. Do đó, lấy $x,y in H$, thì $x<1$ và $y<1$, nên $x*y=x+y-x y=(1-y)(x-1)+1<1 => x*y in H$. Lấy $x in H$, có $x^(-1)=1/(x-1)+1 =>$, do $x<1$ nên $x^(-1) <1 in H$. Do đó, $H <=G$.

  *d)* Ta chứng minh $phi$ là đồng cấu, thật vậy, lấy $x,y in G$, có $phi(x*y)=1-(x*y)=1-(x+y-x y)=(1-x)(1-y)=phi(x) phi(y)$, do đó $phi$ là đồng cấu. Ta chứng minh $phi$ là song ánh.

  Lấy $x,y in G$, giả sử $phi(x)=phi(y) <=> 1-x=1-y<=> x=y$, do đó $phi$ là đơn ánh.

  Lấy $y in RR\{0}$, tìm $x in G$, sao cho $phi(x)=y<=> 1-x=y => "chọn" x=1-y in G "vì" y!=0$, do đó $phi$ là toàn ánh.
  Suy ra, $phi$ là đẳng cấu nhóm.

   *Câu 2*

   *a)* Xét
   $
   sigma=mat(1, 3, 2, 5) mat(2 ,7 ,6, 4 ,3) mat(1, 3, 8, 9, 2) in S_9
   $
   Khi đó, có $
   1&->3->2->5\ 2&->1->1->3\
   3&->8->8->8\
   4&->4->3->2\
   5&->5->5->1\
   6&->6->4->4\
   7&->7->6->6\
   8&->9->9->9\
   9&->2->7->7\
   $
   Do đó, $
   sigma=mat(1,2,3,4,5,6,7,8,9;5,3,8,2,1,4,6,9,7 )=mat(1,5) mat(2,3,8,9,7,6,4,)
   $
   Lại có,
   $
   mat(5,3,8,2,1,4,6,9,7;1,2,3,4,5,6,7,8,9)=mat(1,2,3,4,5,6,7,8,9;5,4,2,6,1,7,9,3,8)=mat(1,5) mat(2,4,6,7,9,8,3)=sigma^(-1)
   $
   Số nghịch thế của $sigma$ là :
 
- $i = 1$, ta có $sigma(i) = 5$, khi đó ta có $j in {2, 4, 5, 6}$.
- $i = 2$, ta có $sigma(i) = 3$, khi đó ta có $j in {4, 5}$.
- $i = 3$, ta có $sigma(i) = 8$, khi đó ta có $j in {4, 5, 6, 7, 9}$.
- $i = 4$, ta có $sigma(i) = 2$, khi đó ta có $j in {5}$.
- $i = 5$, ta có $sigma(i) = 1$, khi đó ta không có giá trị $j$ thỏa mãn.
- $i = 6$, ta có $sigma(i) = 4$, khi đó ta không có giá trị $j$ thỏa mãn.
- $i = 7$, ta có $sigma(i) = 6$, khi đó ta không có giá trị $j$ thỏa mãn.
- $i = 8$, ta có $sigma(i) = 9$, khi đó ta có $j in {9}$.

Vậy tổng số nghịch thế là $S = 4 + 2 + 5 + 1 + 1 = 13$. Do số nghịch thế là số lẻ nên $sigma$ là hoán vị lẻ. Hay $s g n(sigma)=-1$.

*c)* Cấp của $sigma=lcm(2,7)=14$.

*Câu 3*
Lấy $x,y in G$ ta chứng minh $x y= y x$. Từ giả thiết, ta có
$
x^7 y^8=y^8 x^7
$
Mặt khác, từ hệ quả của định lý Largange, ta luôn có
$|x| | 15 , forall x in G => x^15=e$.
Hơn nữa, ta dùng bổ đề sau, nếu $x y = y x $, thì $x^m y^n =y^ n x^m$.

Suy ra, có
$
x y&= x x^15 y y^15\
&= x^2 (x^7)^2 (y^(8))^2=x^2 y (x^7)^2=x^2 y x^(-1) " do" x^14.x=e => x^(-1)=x^14=> y=x y x^-1 => y x=x y
$
Vậy, $G$ giao hoán.




   
]
#pagebreak()
== 2024-2025

#cau[
  Cho $G = (0;1) union (1;+oo)$ và phép toán $ast$ xác định bởi:

  $ x ast y = y^(log_2 x) quad "với mọi" x,y in G. $

  a) Chứng minh $(G, ast)$ là nhóm.

  b) Cho $a = 1/2$ và $b = 4$. Xác định cấp của $a$ và cấp của $b$ trong nhóm $(G, ast)$.
]

#cau[
  Cho $sigma = (1 2 3 4 5)(6 7 4 5 8)(1 8 4 7 9 5) in S_9$.

  a) Phân tích $sigma$ và $sigma^(-1)$ thành tích các chu trình rời nhau.

  b) Xác định cấp của $sigma$.
]

#cau[
  Cho $G, G'$ là các nhóm, $f: G -> G'$ là một toàn cấu nhóm và $H$ là nhóm con chuẩn tắc của $G$. Đặt

  $ f(H) = {f(h) | h in H}. $

  Chứng minh rằng $f(H)$ là nhóm con chuẩn tắc của $G'$.
]

#cau[
  Cho $G$ là một nhóm và $a,b in G$ sao cho $a$ có cấp $5$ và $a^2 b = b a^2$.

  Chứng minh rằng $a b = b a$.
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

  *a)* 
  - Đóng : Lấy $x,y in G$, có $x *y=y^(log_2 x)$, vì $x in G => x>0 "và" x!=1$, do đó $log_2 x !=0 => y^(log_2 x)!=1 => x*y in G$.
  - Kết hợp: Lấy $x,y,z in G$, có
  $
  (x*y)*z=z^(x*y)=z^(log_2 y^(log_2 x))=z^(log_2 y log_2 x)=x*(y*z)
  $
  - Trung hòa: Tìm $e in G$, thỏa $forall x in G$, $x*e=e*x=x$. Có $x*e=e^(log_2 x)=x <=>log_2 e=1 "do" log_2 x!=0$. Do đó, $e=2$.

  - Khả nghịch : Lấy $x in G$, tìm $y in G$ thỏa $x*y=y*x=e$. Thật vậy, có
  $
  x*y=y^(log_2 2)=2<=> log_2 y log_2 x=1<=> log_2 y=1/(log_2 x)<=> y=2^(1/(log_2 x)) in G. 
  $
  *b)* Ta có nhận xét, 
  $
  forall x in G, x^(*n)=x^((log_2 x)^(n-1)),forall n>=1
  $
  Do đó, xét $x=1/2$, ta có $
  (1/2)^(*n)=2 <=> (1/2)^(log_2 1/2)^(n-1) =2<=>2^(n-1)=2 <=> n=2 => |1/2|=2
  $
  Xét $x=4$, ta có 
  $
  4^(*n)=2 <=> 4^(2)^(n-1)=2 <=>2^(2^n)=2 <=> n=0 => |4|=infinity
  $

  *Câu 2*

  *a)* Xét 
  $
  sigma=mat(1,2,3,4,5) mat(6,7,4,5,8) mat(1,8,4,7,9,5) in S_9
  $
  Có :
  $
  1&->8->6->6\
  2&->2->2->3\
  3&->3->3->4\
  4&->7->4->5\
  5&->1->1->2\
  6&->6->7->7\
  7&->9->9->9\
  8&->4->5->1\
  9&->5->8->8
  $
  Suy ra,
  $
  sigma=mat(1,2,3,4,5,6,7,8,9;6,3,4,5,2,7,9,1,8)=mat(1,6,7,9,8) mat(2,3,4,5)
  $
  Và, có
  $
  mat(6,3,4,5,2,7,9,1,8;1,2,3,4,5,6,7,8,9)=mat(1,2,3,4,5,6,7,8,9;8,5,2,3,4,1,6,9,7)=mat(1,8,9,7,6) mat(2,5,4,3)
  $
  *b)* Có $|sigma| =lcm(5,4)=20$.

  *Câu 3*

  Với $H triangle.l G$. Ta đặt $f : G-> G'$ là một toàn cấu nhóm, khi đó ta chứng minh $f(H)={f(h):h in H} triangle.l G'$.

  Ta chứng minh $f(H)<=G$. Vì $H triangle.l G$, nên đặc biệt $H<=G$. Hơn nữa, có $f (e_G) in f(H) "vì" e_G in H$. Do đó, $f(H) "khác rỗng"$. Lấy $x,y in f(H) => exists x',y' in H : f(x')=x , f(y')=y$, khi đó có $x.y=f(x'). f(y')=f(x' y') in f(H),"do x'.y'" in H => x y in f(H)$. Hơn nữa, lấy $x in f(H)$, do đó có $x_1 in H : f(x_1)=x=> x^(-1)=(f(x_1)^(-1))=f(x_1^(-1)) in f(H) "do" x_1 in H =>x_1^(-1) in H$. Do đó, $f(H)<=G'$.

  Ta chứng minh $f(H) triangle.l G'$, thật vậy lấy tùy ý $g in G'$ và $h in f(H)$, ta chứng minh $g h g^(-1) in f(H)$. Thật vậy, có $h in f(H) => exists h_1 in H : f(h_1)=h$. Hơn nữa, từ $g in G'$, do $f$ toàn ánh, suy ra luôn tìm được $g_1 in G$ sao cho $f(g_1)=g$. Do đó,
  $
  g h g^(-1)=f(g_1) f(h_1) f(g_1^(-1))=f(g_1 h_1 g_1 ^(-1)) in f(H) "do" g_1 h_1 g_1 in H "vì" H triangle.l G.
  $

  *Câu 4* Xét nhóm $G$ với $a,b in G$ thỏa $a^5=e$ và $a^2 b=b a^2$. Khi đó, cần chứng minh $a b = b a$.

  Xuất phát từ điều cần chứng minh, ta xét $x=a b a^(-1)$, ta cần chứng minh $x=b$. Thật vậy, từ $a^5=e => a^4 a =e <=> (a^(2))^2 a=e<=> a^(-1)=(a^2)^2$. Do đó,
  $
  a b a^(-1)=a b a^2 a^2=a a^2 b a^2=a^3 a^2 b=a^5 b=b => a b= b a
  $
]
#pagebreak()

== 2023-2024
#cau[
  Cho $G = QQ backslash {3}$ là tập các số hữu tỷ khác $3$. Với mỗi $x, y in G$, đặt
  $x ast y = 2x y - 6x - 6y + 21$.

  a) Chứng minh $(G, ast)$ là một nhóm.

  b) Tìm tất cả các phần tử có cấp hữu hạn của $(G, ast)$.
]


#cau[
  a) Cho $G$ là một nhóm sao cho với mọi $x, y in G$ ta có
  $(x y)^2 = x^2 y^2$.
  Chứng minh rằng $G$ là nhóm abel.

  b) Cho $G$ là nhóm và $H$ là nhóm con chuẩn tắc của $G$.
  Chứng minh rằng nếu $x, y in G$ thì sao cho $x y in H$ thì $y x in H$.
]

#cau[
  Cho nhóm hoán vị $S_4$ và
  $sigma = (1 quad 2 quad 3 quad 4)$,
  $tau = (1 quad 4 quad 2) in S_4$.

  Gọi $H$ là nhóm con cyclic của $S_4$ sinh bởi $sigma$.
  Hãy liệt kê tất cả các phần tử của $H$, $tau H$ và $H tau$.
]

#cau[
  a) Tìm nghịch đảo của các phần tử $overline(9)$ và $overline(17)$ trong $ZZ_41$.

  b) Cho ánh xạ $f: ZZ_20 -> ZZ_20$ xác định bởi
  $f(x) = 4x$.

  Chứng minh rằng $f$ là một đồng cấu nhóm.
  Xác định $ker f$ và $im f$.
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
  - Đóng : Lấy $x,y in G$, có $x*y=2 x y -6x -6y+21=2 x(y-3)-6y+21=2 x(y-3)-6(y-3)+3=2 x(y-3)-6(y-3)+3=(y-3)(2x-6)+3=2(y-3)(x-3)+3$.

  - Kết hợp : Lấy $x,y,z in G$, có $(x*y)*z=2(x*y-3)(z-3)+3=2[(2(y-3)(x-3)+3)(z-3)]+3=x*(y*z)$.

  - Đơn vị : Tìm $e in G$, sao cho $forall x in G$, thỏa $x*e=e*x=x$. Có
  $
  x*e=2(x-3)(e-3)+3=x<=>2(x-3)(e-3)-(x-3)=0<=>(x-3)(2(e-3)-1)=0<=>e=7/2 in QQ.
  $
  - Khả nghịch : Lấy $x in G$, tìm $y in G$, thỏa $forall x in G: x*y=y*x=e$, có
  $
  x*y=2(x-3)(y-3)+3=7/2<=>(x-3)(y-3)=1/4<=>y=1/(4(x-3))+3 in G
  $
  Hơn nữa, $G$ giao hoán, lấy $x,y in G$, có $x*y=2 x y -6 x -6y+21=2 y x -6y -6x+21=y*x, "do đó" x*e=e*x=x, x*x^(-1)=x^(-1)x=e$.

  Suy ra, $(G,*)$ là nhóm.

  *b)*
  Bằng quy nạp, ta dễ dàng chứng minh được :
  $
  x^(*n)=2(x-3)^n+3 ,forall n>=1
  $
  Do đó, nếu $x^(*n)=e <=> 2(x-3)^n+3=7/2<=>(x-3)^n=1/4$, Do đó, để $(x-3)^n=1/4$ thì $x=e <=> x=7/2$. Do đó, tập các phần tử có cấp hữu hạn là ${e}$.

  *Câu 2*

  *a)* Từ giả thiết,
  $
  (x y)^2=x^2 y^2, forall x,y in G <=> x y x y =x^2 y^2 <=> y x = x y ,forall x,y in G
  $
  *b)* Vì $H triangle.l G$, nên ta có $forall g in G, forall h in H, g h g^(-1) in H$. Mặt khác, với $x,y in G$ giả sử $x y in H$, khi đó ta có
  $
  y x = x^(-1) (x y) x
  $
  Từ giả thiết với $H$ chuẩn tắc trong G, khi đó xét $g=x^(-1)$ và $h= x y in H$, ta có điều phải chứng minh.

  *Câu 3*

  Xét nhóm hoán vị $S_4$, ta có nhận xét : $sigma^4=e=I_d $, do đó nhóm cyclic sinh bởi $sigma$, có $4$ phần tử, ta đặt $H=chevron.l sigma chevron.r$. Ta có
  $
  H={e,sigma,sigma^2,sigma^3}
  $
  Trong đó, $
  sigma^2=mat(1,2,3,4) mat(1,2,3,4)=mat(1,3) mat(2,4)
  $
  Và $
  sigma^3=mat(1,2,3,4) mat(1,3) mat(2,4)=mat(1,4,3,2)
  $
  Do đó,
  $
  H={e,mat(1,2,3,4),mat(1,3)mat(2,4),mat(1 ,4,3,2)}
  $
  Suy ra, 
  $
  tau H={t h: h in H}={mat(1,4,2),mat(3,4),mat(1,3)}
  $
  và $
  H tau={h t : h in H}={mat(1,4,2),mat(1,2,3),mat(1,3,2,4)}
  $


  *Câu 4*
  
   Dễ thấy $gcd(9,41)=1$ và $gcd(17,41)=1$, do đó tồn tại $(overline(9))^(-1)$ và $(overline(17))^(-1)$. Hơn nữa, thực hiện phép chia Euclid, ta được
  $
  41 &=4 times 9 +5\
  9 &= 1 times 5 +4\
  5 &= 1times 4 +1\
  => 1 &=5-1 times 4= 5-(9-5)=2 times 5 -9= 2times(41-4times 9)-9=2times 41 -9 times 9
  $
  Do đó, $overline(9)^(-1)=overline(-9)=overline(32)$.

  Tương tự, ta tìm được $overline(17)^(-1)=overline(-12)=overline(29)$
  
  *b)* Lấy $overline(x),overline(y) in Z_(20)$, khi đó ta có
  $
  f(overline(x)+overline(y))=f(overline(x+y))=overline(4(x+y))=overline(4 x)+overline(4 y)=f(overline(x))+f(overline(y))
  $
  Do đó, $f$ là đồng cấu nhóm, hơn nữa
  $
  ker f={overline(x) in Z_20 : f(overline(x))=overline(0)} <=> 4times overline(x)= overline(0) <=> 20 | 4 x => x= 5 k, k in ZZ
  $
  Do đó, $ker f={5 k : k in ZZ}$. Hơn nữa, có $I m f={f(overline(x)) : x in Z_20}={ 4 overline(x) : overline(x) in Z_20}$.
]
#pagebreak()
== 2022-2023

#cau[
  Cho $G = RR^+ backslash {1}$ là tập các số thực dương khác $1$. Với mỗi $x, y in G$, đặt
  $x ast y = x^(log_3 y)$.

  a) Chứng minh $(G, ast)$ là một nhóm aben.

  b) Tìm tất cả các phần tử có cấp hữu hạn của nhóm $(G, ast)$.
]

#cau[
  Cho hoán vị
  $
  sigma = mat(
    1, 2, 3, 4, 5, 6, 7, 8;
    8, 4, 3, 2, 7, 6, 1, 5
  )
  $

  a) Biểu diễn $sigma$ và $sigma^2$ thành tích các chu trình rời nhau.

  b) Xác định cấp của $sigma$ và $sigma^2$.
]

#cau[
  Đặt $G = G L_2(RR)$ là nhóm nhân các ma trận cấp $2$ khả nghịch trên $RR$ và đặt
  $H = {mat(1, a; 0, 1) | a in RR}$.

  a) Chứng minh rằng $H$ là nhóm con của $G$.

  b) $H$ có là nhóm con chuẩn tắc của $G$ hay không? Giải thích.

  c) Chứng minh rằng mọi phần tử khác đơn vị trong $H$ đều có cấp vô hạn.
]

#cau[
  Cho $G, G'$ là hai nhóm hữu hạn và $f: G -> G'$ là một toàn cấu nhóm.

  a) Chứng minh rằng, nếu có một phần tử cấp $n$ thuộc $G'$ thì cũng có một phần tử cấp $n$ thuộc $G$.

  b) Cho một ví dụ cụ thể về $G, G'$ và $n$ sao cho $G$ chứa một phần tử cấp $n$ mà $G'$ không chứa phần tử cấp $n$.
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
  a) Chứng minh $(G, *)$ là một nhóm abel.

- *Đóng:* Lấy $x, y in G$, khi đó $x > 0$, $y > 0$ và $x != 1$, $y != 1$. Ta có

  $ x * y = x^(log_3 y) > 0. $

  Mặt khác,

  $ log_3 (x * y) = (log_3 x)(log_3 y) != 0 $

  do $log_3 x != 0$ và $log_3 y != 0$.

  Suy ra $x * y != 1$, nên $x * y in G$.

- *Kết hợp:* Lấy $x, y, z in G$, có

  $ (x * y) * z
    = (x^(log_3 y))^(log_3 z)
    = x^((log_3 y)(log_3 z)). $

  Và

  $ x * (y * z)
    = x^(log_3 (y^(log_3 z)))
    = x^((log_3 y)(log_3 z)). $

  Do đó $(x * y) * z = x * (y * z)$.

- *Đơn vị:* Tìm $e in G$ sao cho $forall x in G$,

  $ x * e = e * x = x. $

  Có

  $ x * e = x
    <=> x^(log_3 e) = x
    <=> log_3 e = 1
    <=> e = 3. $

  Hơn nữa,

  $ 3 * x = 3^(log_3 x) = x. $

  Do đó, chọn $e = 3 in G$.

- *Khả nghịch:* Lấy $x in G$, tìm $y in G$ sao cho $x * y = y * x = e = 3$. Có

  $ x * y = 3
    <=> x^(log_3 y) = 3
    <=> (log_3 x)(log_3 y) = 1
    <=> log_3 y = 1/(log_3 x)
    <=> y = 3^(1/(log_3 x)). $

  Vì $log_3 x != 0$ nên $y > 0$ và $y != 1$, suy ra $y in G$.

  Mặt khác, $y * x = x * y = 3$.

  Vậy mọi phần tử của $G$ đều có phần tử nghịch đảo.

- *Giao hoán:* Lấy $x, y in G$, có

  $ x * y
    = x^(log_3 y)
    = 3^((log_3 x)(log_3 y))
    = 3^((log_3 y)(log_3 x))
    = y^(log_3 x)
    = y * x. $

  Suy ra $(G, *)$ là một nhóm abel.

b) Tìm tất cả các phần tử có cấp hữu hạn.

Ký hiệu $x^([n])$ là tích của $n$ phần tử $x$ theo phép toán $*$.

Bằng quy nạp, ta chứng minh được

$ x^([n]) = 3^((log_3 x)^n), quad forall n >= 1. $

Thật vậy, với $n = 1$,

$ x^([1]) = x = 3^(log_3 x). $

Giả sử công thức đúng với $n >= 1$. Khi đó,

$ x^([n+1])
  = x^([n]) * x
  = (3^((log_3 x)^n))^(log_3 x)
  = 3^((log_3 x)^(n+1)). $

Vậy công thức đúng với mọi $n >= 1$.

Do đó, $x in G$ có cấp hữu hạn khi và chỉ khi tồn tại $n >= 1$ sao cho

$ x^([n]) = e
  <=> 3^((log_3 x)^n) = 3
  <=> (log_3 x)^n = 1. $

Vì $log_3 x in RR$, ta có:

- Nếu $n$ lẻ thì $log_3 x = 1$, suy ra $x = 3$.
- Nếu $n$ chẵn thì $log_3 x = plus.minus 1$, suy ra $x = 3$ hoặc $x = 1/3$.

Mặt khác, phần tử $3$ có cấp $1$, còn

$ 1/3 * 1/3 = (1/3)^(-1) = 3 $

nên phần tử $1/3$ có cấp $2$.

Vậy tập tất cả các phần tử có cấp hữu hạn của $G$ là

$ {3, 1/3}. $

*Câu 2*

Cho hoán vị

$ sigma = mat(
  1, 2, 3, 4, 5, 6, 7, 8;
  8, 4, 3, 2, 7, 6, 1, 5
). $

a) Biểu diễn $sigma$ và $sigma^2$ thành tích các chu trình rời nhau.

Ta có

$ 1 -> 8 -> 5 -> 7 -> 1, $

$ 2 -> 4 -> 2. $

Ngoài ra, $sigma(3) = 3$ và $sigma(6) = 6$.

Do đó,

$ sigma = (1 quad 8 quad 5 quad 7)(2 quad 4). $

Vì các chu trình trên rời nhau nên

$ sigma^2
  = (1 quad 8 quad 5 quad 7)^2 (2 quad 4)^2
  = (1 quad 5)(8 quad 7). $

b) Xác định cấp của $sigma$ và $sigma^2$.

Vì $sigma$ là tích của hai chu trình rời nhau có độ dài lần lượt là $4$ và $2$, nên

$ "ord"(sigma) = "lcm"(4, 2) = 4. $

Tương tự, $sigma^2$ là tích của hai chu trình rời nhau có độ dài $2$, nên

$ "ord"(sigma^2) = "lcm"(2, 2) = 2. $

Vậy cấp của $sigma$ và $sigma^2$ lần lượt là $4$ và $2$.

*Câu 3*

Đặt

$ A(a) = mat(1, a; 0, 1), quad a in RR. $

Khi đó $H = {A(a) | a in RR}$.

a) Chứng minh $H$ là nhóm con của $G$.

Ta có

$ A(0) = mat(1, 0; 0, 1) = I_2 in H, $

nên $H != emptyset$.

Lấy $A(a), A(b) in H$ với $a, b in RR$. Khi đó,

$ A(a) A(b)
  = mat(1, a; 0, 1) mat(1, b; 0, 1)
  = mat(1, a+b; 0, 1)
  = A(a+b) in H. $

Mặt khác,

$ A(a)^(-1)
  = mat(1, -a; 0, 1)
  = A(-a) in H. $

Do đó, $H$ là một nhóm con của $G$.

b) Xét xem $H$ có là nhóm con chuẩn tắc của $G$ hay không.

Chọn

$ P = mat(0, 1; 1, 0) in G, quad
  A(1) = mat(1, 1; 0, 1) in H. $

Vì $P^(-1) = P$, nên

$ P A(1) P^(-1)
  = mat(0, 1; 1, 0)
    mat(1, 1; 0, 1)
    mat(0, 1; 1, 0)
  = mat(1, 0; 1, 1) in.not H. $

Do đó, tồn tại $P in G$ và $A(1) in H$ sao cho

$ P A(1) P^(-1) in.not H. $

Suy ra $H$ không là nhóm con chuẩn tắc của $G$.

c) Chứng minh mọi phần tử khác đơn vị trong $H$ đều có cấp vô hạn.

Lấy $A(a) in H$ sao cho $A(a) != I_2$, suy ra $a != 0$.

Bằng quy nạp, ta chứng minh được

$ A(a)^n = mat(1, n a; 0, 1), quad forall n >= 1. $

Thật vậy, với $n = 1$, công thức hiển nhiên đúng.

Giả sử công thức đúng với $n >= 1$. Khi đó,

$ A(a)^(n+1)
  = A(a)^n A(a)
  = mat(1, n a; 0, 1)
    mat(1, a; 0, 1)
  = mat(1, (n+1)a; 0, 1). $

Vậy công thức đúng với mọi $n >= 1$.

Giả sử $A(a)$ có cấp hữu hạn, khi đó tồn tại $n >= 1$ sao cho

$ A(a)^n = I_2. $

Suy ra

$ mat(1, n a; 0, 1)
  = mat(1, 0; 0, 1)
  => n a = 0
  => a = 0, $

mâu thuẫn với $a != 0$.

Do đó, mọi phần tử khác đơn vị trong $H$ đều có cấp vô hạn.

*Câu 4*

a) Giả sử $G'$ có một phần tử cấp $n$. Chứng minh $G$ cũng có một phần tử cấp $n$.

Lấy $b in G'$ sao cho $"ord"(b) = n$.

Vì $f: G -> G'$ là một toàn cấu nhóm nên tồn tại $a in G$ sao cho

$ f(a) = b. $

Do $G$ hữu hạn, đặt $"ord"(a) = m$.

Khi đó $a^m = e_G$, suy ra

$ b^m = f(a)^m = f(a^m) = f(e_G) = e_(G'). $

Vì $"ord"(b) = n$ nên $n | m$.

Do đó, tồn tại $k in NN^*$ sao cho $m = n k$.

Xét phần tử $a^k in G$.

Ta có

$ (a^k)^n = a^(k n) = a^m = e_G. $

Mặt khác, giả sử tồn tại $r >= 1$ sao cho

$ (a^k)^r = e_G. $

Khi đó,

$ a^(k r) = e_G
  => m | k r
  => n k | k r
  => n | r. $

Vậy $n$ là số nguyên dương nhỏ nhất thỏa mãn

$ (a^k)^n = e_G. $

Suy ra

$ "ord"(a^k) = n. $

Do đó, $G$ chứa một phần tử có cấp $n$.

b) Cho ví dụ về $G, G'$ và $n$ sao cho $G$ chứa phần tử cấp $n$ nhưng $G'$ không chứa phần tử cấp $n$.

Chọn

$ G = (ZZ_4, +), quad G' = (ZZ_2, +), quad n = 4. $

Xét ánh xạ

$ f: ZZ_4 -> ZZ_2, quad f([k]_4) = [k]_2. $

Dễ thấy $f$ là một toàn cấu nhóm.

Mặt khác, trong $ZZ_4$, phần tử $[1]_4$ có cấp $4$, còn trong $ZZ_2$, mọi phần tử đều có cấp không vượt quá $2$.

Do đó, $G$ chứa phần tử cấp $4$ nhưng $G'$ không chứa phần tử cấp $4$.

Vậy ta có ví dụ cần tìm. Có thể chọn nhóm $G=ZZ_2$ và $G'={0}$.
]
#pagebreak()
== 2021-2022

#cau[
  Cho $G = RR backslash {-1}$ là tập các số thực khác $-1$. Với mỗi $x, y in G$, đặt
  $x ast y = x + y + x y$.

  a) Chứng minh $(G, ast)$ là một nhóm aben.

  b) Tìm tất cả các phần tử có cấp hữu hạn của nhóm $(G, ast)$.

  c) Đặt $H = ZZ backslash {-1}$ là tập các số nguyên khác $-1$. Xác định $(H, ast)$ có là nhóm con của $(G, ast)$ hay không? Giải thích.
]

#cau[
  a) Cho $G$ là một nhóm sao cho
  $forall a, b in G, (a b)^2 = a^2 b^2$.

  Chứng minh rằng $G$ là nhóm aben.

  b) Cho một ví dụ về một nhóm $G$ và hai phần tử $a, b in G$ sao cho $(a b)^2 != a^2 b^2$.
]

#cau[
  Cho ánh xạ $f: (RR, +) -> (RR^(*), dot)$ xác định bởi $f(x) = 2^x$.

  a) Chứng minh $f$ là một đồng cấu nhóm.

  b) Xác định $im f$ và $ker f$.
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

  *a)*
  - Đóng : Lấy $x,y in G$, khi đó có
  $
  x*y=x+y+x y=x(1+y)+(y+1)-1=(x+1)(y+1)-1 in G "vì x khác -1 và y khác -1".
  $

  - Kết hợp : Lấy $x,y,z in G$, có
  $
  (x*y)*z=(x*y+1)(z+1)-1=(x+1)(y+1)(z+1)-1=x*(y*z)
  $
  - Đơn vị : Tìm $e in G$, sao cho $forall x in G, x*e=e*x=x$. Có
  $
  x*e=(x+1)(e+1)-1=x <=> (x+1)(e+1)-(x+1)=0 <=> (x+1)(e+1-1)=0 => e=0 "do x khác -1".
  $
  Do đó, chọn $e=0 in G$.
  - Khả nghịch : Lấy $x in G$, tìm $y in G$ sao cho $x*y=y*x=e$. Có
  $
  x*y=(x+1)(y+1)-1=0 <=> y=1/(x+1) -1 in G
  $
  - Giao hoán :
  Lấy $x,y in G$, có $x*y=x+y+x y=y+x+y x= y*x$, suy ra $(G,*)$ là nhóm abel.

  *b)* Bằng quy nạp, ta chứng minh được rằng 
  $
  x^(*n)=(x+1)^n -1 ,forall n>=1
  $
  Do đó, nếu $x^(*n)=e <=> (x+1)^n=1 => x=-2, "nếu n chẵn", x=0 "nếu n lẻ"$. Vậy tập tất cả các phần tử hữu hạn của $G$ là ${0,-2}$.

  *c)* H không là nhóm con của $G$ vì, với $x in H,x^(-1)=1/(x+1)-1 in.not H$, thật vậy, xét $x=-3$ thì $x^(-1)=1/(-2) -1 in.not H$.


  *Câu 2*

  *a)* Lấy $x,y in G$, ta có
  $
  (x y)^2 =x^2 y^2 <=>x y x y =x^2 y^2 <=> y x = x y
  $
  Do đó, $G$ là nhóm abel

  *b)* Xét nhóm $S_3$ và chọn $a=mat(1,2),b=mat(2,3)$.

  *Câu 3*

  *a)* Lấy $x,y in (RR,+)$. Khi đó, $
  f(x+y)=2^(x+y)=2^(x) 2^(y)= f(x) f(y)
  $
  Suy ra, $f$ là đồng cấu nhóm.

  *b)* Có $
  I m f={f(x) in RR^+: x in RR}.
  $
  Và 
  $
  ker f={ x in RR : f(x)=1 } => ker f={0}.
  $

]
#pagebreak()
== Đề Luyện Tập

#align(center)[
  #text(size: 16pt, weight: "bold", fill: blue)[ĐỀ THI GIỮA KỲ — ĐỀ SỐ 1]
]
#align(center)[*Thời gian: 90 phút — Mức độ: Trung bình – Khá*]
#v(0.8em)

#cau[
  *Câu 1 (3 điểm).* Cho $G = RR ∖ {-2}$ và phép toán $*$ xác định bởi
  $ x * y = x + y + (x y)/2, quad forall x, y in G. $

  a) Chứng minh $(G, *)$ là một nhóm abel.

  b) Tìm tất cả các phần tử có cấp hữu hạn của $(G, *)$.

  c) Chứng minh $H = (-2, +infinity)$ là một nhóm con của $G$.

  d) Xét ánh xạ $phi: (G, *) -> (RR ∖ {0}, dot)$ xác định bởi
  $ phi(x) = 1 + x/2. $
  Chứng minh $phi$ là một đẳng cấu nhóm.
]

#cau[
  *Câu 2 (2,5 điểm).* Cho
  $ sigma = mat(1, 3 ,5, 7)mat(2 ,8 ,4 ,6, 9)mat(1, 6, 3, 9, 5) in S_9. $

  a) Phân tích $sigma$ và $sigma^(-1)$ thành tích các chu trình rời nhau.

  b) Đếm số nghịch thế của $sigma$ và xác định tính chẵn lẻ của $sigma$.

  c) Xác định cấp của $sigma$.
]

#cau[
  *Câu 3 (2 điểm).* Cho $G$ là một nhóm hữu hạn có cấp lẻ. Giả sử
  $ a^2 b = b a^2, quad forall a, b in G. $
  Chứng minh rằng $G$ là nhóm abel.
]

#cau[
  *Câu 4 (2,5 điểm).* Xét hai nhóm cộng $ZZ_36$ và $ZZ_24$. Cho ánh xạ
  $ f: ZZ_36 -> ZZ_24, quad f(overline(x)) = overline(2 x). $

  a) Chứng minh $f$ là một đồng cấu nhóm, bao gồm việc kiểm tra tính xác định tốt.

  b) Xác định $"Ker" f$ và $"Im" f$.

  c) Áp dụng định lý đẳng cấu thứ nhất để xác định cấu trúc của nhóm thương $ZZ_36 \/ "Ker" f$.

  d) *Phân loại:* Tìm tất cả các đồng cấu nhóm từ $(ZZ_36, +)$ đến $(ZZ_24, +)$. Có bao nhiêu đồng cấu như vậy? Có đồng cấu nào là toàn ánh không?
]

#loigiai[

  *Câu 1* 
  
  *Đóng* : Lấy $x,y in G$, có $x*y=x+y+(x y)/2=x(1+y/2)+2(1+y/2)-2=(x+2)(y+1/2)-2=1/4(x+2)(4y+2)-2$
 Giả sử ta xét
]
#pagebreak()
#align(center)[
  #text(size: 16pt, weight: "bold", fill: blue)[ĐỀ THI GIỮA KỲ — ĐỀ SỐ 2]
]
#align(center)[*Thời gian: 90 phút — Mức độ: Khá*]
#v(0.8em)

#cau[
  *Câu 1 (3 điểm).* Cho tập hợp
  $ G = {(a, b) in RR^2 | a != 0} $
  và phép toán $*$ xác định bởi
  $ (a, b) * (c, d) = (a c, a d + b). $

  a) Chứng minh $(G, *)$ là một nhóm. Nhóm này có giao hoán không?

  b) Cho $H = {(1, t) | t in RR}$. Chứng minh $H$ là nhóm con chuẩn tắc của $G$.

  c) Xét ánh xạ $f: G -> RR ∖ {0}$, với $f(a, b) = a$. Chứng minh $f$ là một toàn cấu nhóm, trong đó tập đích được trang bị phép nhân thông thường.

  d) Áp dụng định lý đẳng cấu thứ nhất để chứng minh
  $ G \/ H ≅ (RR ∖ {0}, dot). $
]

#cau[
  *Câu 2 (2 điểm).* Cho
  $ sigma = (1 4 7 3)(2 8 6)(1 5 3 8) in S_8. $

  a) Phân tích $sigma$ và $sigma^(-1)$ thành tích các chu trình rời nhau.

  b) Xác định tính chẵn lẻ và cấp của $sigma$.

  c) *Phân loại:* Tìm tất cả các số nguyên $k$ sao cho $sigma^k$ có cấp đúng bằng $3$.
]

#cau[
  *Câu 3 (2,5 điểm).* Cho $G$ là một nhóm và $H$ là nhóm con chuẩn tắc của $G$.

  a) Chứng minh rằng nếu $G \/ H$ là nhóm abel thì
  $ a^(-1) b^(-1) a b in H, quad forall a, b in G. $

  b) Chứng minh điều ngược lại: nếu
  $ a^(-1) b^(-1) a b in H, quad forall a, b in G, $
  thì $G \/ H$ là nhóm abel.

  c) *Phân loại:* Giả sử thêm rằng $G \/ H$ là nhóm cyclic và $H subset.eq Z(G)$, trong đó $Z(G)$ là tâm của $G$. Chứng minh rằng $G$ là nhóm abel.
]

#cau[
  *Câu 4 (2,5 điểm).* Xét ánh xạ giữa hai nhóm cộng
  $ f: ZZ times ZZ -> ZZ_15, quad f(m, n) = overline(5 m + 3 n). $

  a) Chứng minh $f$ là một đồng cấu nhóm.

  b) Xác định $"Ker" f$, $"Im" f$. Chứng minh $f$ là toàn ánh.

  c) Áp dụng định lý đẳng cấu thứ nhất để suy ra
  $ ZZ_3 times ZZ_5 ≅ ZZ_15. $

  d) *Phân loại:* Tổng quát hóa: cho hai số nguyên dương $m, n$. Chứng minh
  $ ZZ_m times ZZ_n ≅ ZZ_(m n) <=> gcd(m, n) = 1. $
]
#loigiai[

  *Câu 3*
  Xét $G$ là nhóm và $H triangle.l G$. Giả sử $G \/ H$ là nhóm abel, ta chứng minh
  $
  a^(-1) b^(-1) a b in H ,forall a,b in G
  $
  Vậy, từ $G \/ H$ là nhóm abel, ta thu được với mỗi $overline(x) in G \/ H$ và $overline(y) in G\/ H$, ta đều có 
  $
  overline(x) overline(y) = overline(y)overline(x) => (x H)(y H)=(y H)(x H)=> (x y)H=(y x) H quad (1)
  $
  Từ (1), xét $e in H$ và bất kỳ $ h in H$. Ta đều có,
  $
  (x y) e=(y x) h=> (x^(-1) y^(-1) x  y) =h => x^(-1) y^(-1) x y in H
  $
  Mà, $x,y$ tùy ý $in G$ do đó ta có điều phải chứng minh.

  *Câu 4*

  *a)* Lấy $x,y in ZZ times ZZ$, đặt $x=(x_1,x_2)$, $y=(y_1,y_2)$. Có, $x+y=(x_1+y_1,x_2+y_2)$, khi đó 
  $
  f(x+y)=f((x_1+y_1),(x_2+y_2))=overline(5(x_1+y_1)+3(x_2+y_2))=5 overline(x_1)+3 overline(x_2)+5(overline(y_1))+3 overline(y_2)=f(x)+f(y)
  $

  *b)*

  Có $ K e r f={x in ZZ times ZZ : f(x)=overline(0)} = {x_1,x_2 in ZZ : overline(5 x_1+3 x_2)=overline(0)} =>15 | (5 x_1 + 3 x_2) $
  Khi đó, ta thấy để $5 x_1 + 3 x _2$ là bội của $15$, do đó tìm được $n in ZZ$ sao cho $5 x_1 + 3 x_2=15 n$. Vậy, cần điều kiện $x_1,x_2 in ZZ$ để thỏa mãn điều trên.
  
  Đặt số dư của $5 x_1$ khi chia cho $15$ là $r$ và số dư của $3 x_2$ khi chia cho $15$ là $q$.

% r+ q  15? // 7+8 =15 //

  Nếu $5 x_1$ và $3 x_2$ cùng dư $0$ khi chia cho $15$, nghĩa là : $15 | 5 x_1 $ và $ 15 | 3 x_2$, suy ra 
  $
  x_1 = 3k ,x_2=5 m, forall k,m in ZZ
  $

  Khi đó, thực hiện phép chia Euclid, ta thu được
  $
5 x_1=h 15+r quad 3 x_2= k 15 + q
  $
  Thay vào, ta được$
h 15+r + k 15+q=15 n => 15(k+q)+ r+ q=15 n=> 15 | k+q
  $


  

]

#pagebreak()

g
#align(center)[
  #text(size: 16pt, weight: "bold", fill: blue)[ĐỀ THI GIỮA KỲ — ĐỀ SỐ 3]
]
#align(center)[*Thời gian: 90 phút — Mức độ: Khá – Khó*]
#v(0.8em)

#cau[
  *Câu 1 (3 điểm).* Cho $G = (0, +infinity)$ và phép toán $*$ xác định bởi
  $ x * y = (x y)/5, quad forall x, y in G. $

  a) Chứng minh $(G, *)$ là một nhóm abel.

  b) Tìm tất cả các phần tử có cấp hữu hạn trong $G$.

  c) Chứng minh ánh xạ $phi: (G, *) -> (RR, +)$ xác định bởi
  $ phi(x) = ln (x/5) $
  là một đẳng cấu nhóm.

  d) *Phân loại:* Cho $H = {5e^n | n in ZZ}$. Chứng minh $H$ là nhóm con chuẩn tắc của $G$. Sử dụng định lý đẳng cấu thứ nhất để chứng minh
  $ G \/ H ≅ (RR \/ ZZ, +). $
]

#cau[
  *Câu 2 (2 điểm).* Cho
  $ sigma = (1 2 7 5 4)(2 8 3 6)(1 9 4 8) in S_9. $

  a) Phân tích $sigma$ và $sigma^(-1)$ thành tích các chu trình rời nhau.

  b) Xác định tính chẵn lẻ và cấp của $sigma$.

  c) *Phân loại:* Tìm tất cả các số nguyên dương $n$ sao cho $sigma^n$ là một $5$-chu trình.
]

#cau[
  *Câu 3 (2 điểm).* Cho $G$ là một nhóm và $a, b in G$.

  a) Giả sử $a$ có cấp $9$ và $a^4 b = b a^4$. Chứng minh $a b = b a$.

  b) *Phân loại:* Xét nhóm hoán vị $S_4$, với
  $ a = (1 2 3 4), quad b = (1 3). $
  Chứng minh rằng $a^2 b = b a^2$ nhưng $a b != b a$.

  Từ đó, giải thích vì sao không thể bỏ điều kiện thích hợp về cấp của $a$ trong bài toán ở câu a).
]

#cau[
  *Câu 4 (3 điểm).* Xét nhóm hoán vị $S_4$ và nhóm cộng $ZZ_2$. Cho ánh xạ $f: S_4 -> ZZ_2$ xác định bởi
  $ f(sigma) = cases(
    overline(0) & "nếu" sigma "là hoán vị chẵn",
    overline(1) & "nếu" sigma "là hoán vị lẻ",
  ) $

  a) Chứng minh $f$ là một toàn cấu nhóm. Xác định $"Ker" f$.

  b) Áp dụng định lý đẳng cấu thứ nhất để chứng minh
  $ S_4 \/ A_4 ≅ ZZ_2. $

  c) *Phân loại:* Chứng minh rằng mọi đồng cấu nhóm $g: S_4 -> ZZ_2$ đều là đồng cấu tầm thường hoặc đồng cấu $f$ đã cho.
]

#pagebreak()

#align(center)[
  #text(size: 16pt, weight: "bold", fill: blue)[ĐỀ THI GIỮA KỲ — ĐỀ SỐ 4]
]
#align(center)[*Thời gian: 90 phút — Mức độ: Khó*]
#v(0.8em)

#cau[
  *Câu 1 (2,5 điểm).* Cho
  $ G = (RR ∖ {0}) times (RR ∖ {0}) $
  với phép toán nhân theo từng thành phần:
  $ (a, b) * (c, d) = (a c, b d). $

  a) Chứng minh $(G, *)$ là một nhóm abel.

  b) Tìm tất cả các phần tử có cấp hữu hạn của $G$.

  c) Cho ánh xạ $f: G -> RR ∖ {0}$, với $f(a, b) = a b$. Chứng minh $f$ là một toàn cấu nhóm, với phép nhân thông thường trên tập đích.

  d) Xác định $"Ker" f$ và áp dụng định lý đẳng cấu thứ nhất để mô tả nhóm $G \/ "Ker" f$.
]

#cau[
  *Câu 2 (2 điểm).* Cho
  $ sigma = (9 5 6 4)(6 7 2 8 1)(3 9 2 6) in S_9. $

  a) Phân tích $sigma$ và $sigma^(-1)$ thành tích các chu trình rời nhau.

  b) Xác định tính chẵn lẻ và cấp của $sigma$.

  c) Tính $sigma^6$.

  d) *Phân loại:* Tìm tất cả các số nguyên $k$ sao cho $sigma^k$ có cấp đúng bằng $3$.
]

#cau[
  *Câu 3 (2,5 điểm).* Cho $G$ là một nhóm. Đặt
  $ Z(G) = {a in G | a x = x a, quad forall x in G}. $

  a) Chứng minh $Z(G)$ là một nhóm con chuẩn tắc của $G$.

  b) *Phân loại:* Giả sử nhóm thương $G \/ Z(G)$ là nhóm cyclic. Chứng minh rằng $G$ là nhóm abel.

  c) Từ câu b), chứng minh rằng nếu $G \/ Z(G)$ có cấp là một số nguyên tố thì $G$ phải là nhóm abel.
]

#cau[
  *Câu 4 (3 điểm).* Xét ánh xạ
  $ f: ZZ_12 times ZZ_18 -> ZZ_6 $
  xác định bởi
  $ f(overline(x), overline(y)) = overline(x + y). $

  a) Chứng minh $f$ là một đồng cấu nhóm xác định tốt.

  b) Xác định $"Ker" f$, $"Im" f$ và lực lượng của $"Ker" f$.

  c) Áp dụng định lý đẳng cấu thứ nhất để chứng minh
  $ (ZZ_12 times ZZ_18) \/ "Ker" f ≅ ZZ_6. $

  d) *Phân loại:* Chứng minh rằng $"Ker" f$ là một nhóm cyclic có cấp $36$. Tìm một phần tử sinh của nhóm này.
]

#pagebreak()

#align(center)[
  #text(size: 16pt, weight: "bold", fill: blue)[ĐỀ THI GIỮA KỲ — ĐỀ SỐ 5]
]
#align(center)[*Thời gian: 90 phút — Mức độ: Khó – Rất khó*]
#v(0.8em)

#cau[
  *Câu 1 (2,5 điểm).* Cho $G = QQ ∖ {1/2}$ và phép toán $*$ xác định bởi
  $ x * y = 2 x y - x - y + 1, quad forall x, y in G. $

  a) Chứng minh $(G, *)$ là một nhóm abel.

  b) Tìm tất cả các phần tử có cấp hữu hạn trong $G$.

  c) Chứng minh ánh xạ $phi: (G, *) -> (QQ ∖ {0}, dot)$ xác định bởi
  $ phi(x) = 2 x - 1 $
  là một đẳng cấu nhóm.

  d) Chứng minh rằng tập hợp
  $ H = {x in QQ | x > 1/2} $
  là một nhóm con chuẩn tắc của $G$.
]

#cau[
  *Câu 2 (2 điểm).* Xét nhóm hoán vị $S_4$. Cho
  $ sigma = (1 2 3 4), quad tau = (1 2). $
  Đặt $H = chevron.l sigma chevron.r$.

  a) Liệt kê tất cả các phần tử của $H$.

  b) Xác định hai lớp ghép $tau H$ và $H tau$. Từ đó chứng minh $H$ không là nhóm con chuẩn tắc của $S_4$.

  c) *Phân loại:* Giải thích vì sao công thức
  $ (x H)(y H) = x y H $
  không xác định được một phép toán trên tập các lớp ghép trái $S_4 \/ H$. Hãy chỉ ra hai cách chọn phần tử đại diện dẫn đến kết quả khác nhau.
]

#cau[
  *Câu 3 (3 điểm).* Cho $G$ là một nhóm, $H, K$ là hai nhóm con của $G$, trong đó $H$ là nhóm con chuẩn tắc của $G$.
  Đặt
  $ H K = {h k | h in H, k in K}. $

  a) Chứng minh $H K$ là một nhóm con của $G$, và $H$ là nhóm con chuẩn tắc của $H K$.

  b) Xét ánh xạ $f: K -> H K \/ H$ xác định bởi
  $ f(k) = k H. $
  Chứng minh $f$ là một toàn cấu nhóm.

  c) Xác định $"Ker" f$.

  d) *Phân loại:* Sử dụng định lý đẳng cấu thứ nhất để suy ra
  $ K \/ (H inter K) ≅ H K \/ H. $

  Yêu cầu chứng minh đầy đủ tính xác định tốt, tính bảo toàn phép toán và tính toàn ánh của ánh xạ được xây dựng.
]

#cau[
  *Câu 4 (2,5 điểm).* Xét hai nhóm cộng $ZZ_18$ và $ZZ_30$.

  a) Chứng minh rằng mọi đồng cấu nhóm $f: ZZ_18 -> ZZ_30$ đều có dạng
  $ f(overline(x)) = overline(k x) $
  với $k in ZZ$ thỏa mãn một điều kiện thích hợp. Hãy tìm điều kiện đó.

  b) Xác định tất cả các đồng cấu nhóm từ $ZZ_18$ đến $ZZ_30$.

  c) Trong các đồng cấu tìm được, có bao nhiêu đồng cấu có ảnh gồm đúng $6$ phần tử?

  d) *Phân loại:* Với từng đồng cấu tìm được ở câu c), hãy xác định hạt nhân và áp dụng định lý đẳng cấu thứ nhất để mô tả nhóm thương tương ứng.
]

#loigiai[


  *a)* Ta chứng minh $f(overline(x))=overline(k x)$ là đồng cấu nhóm, thật vậy
  lấy bất kỳ $x,y in ZZ_18$, ta chứng minh $
f(overline(x y) )=f(overline(x)) f(overline(y))
  $
  Với
  


]


#pagebreak()

=== Đề 05


#cau[
  *Câu 1 (3.0 điểm).* Cho $G = RR ∖ brace.l -1/3 brace.r$. Với mọi $x, y in G$, đặt
  $
    x * y = x + y + 3 x y.
  $

  a. Chứng minh rằng $(G, *)$ là một nhóm giao hoán.

  b. Tìm tất cả phần tử có cấp hữu hạn của nhóm $(G, *)$.
]

#cau[
  *Câu 2 (2.0 điểm).* Trong nhóm $S_6$, cho các hoán vị
  $
    sigma = (1 2 4 6)(2 3 5 6),
  $
  và
  $
    tau = mat(
      1, 2, 3, 4, 5, 6;
      3, 5, 1, 6, 4, 2
    ).
  $

  a. Tìm $alpha in S_6$ sao cho $sigma alpha = tau$.

  b. Phân tích $alpha$ tìm được ở ý a thành tích các chu trình rời nhau và tìm cấp của $alpha$.
]

#cau[
  *Câu 3 (3.0 điểm).* Cho $(G, dot)$ là một nhóm có cấp 13. Chứng minh rằng

  a. $G$ là nhóm cyclic.

  b. Ánh xạ
  $
    phi: G -> G, quad x ↦ x^8
  $
  là một tự đẳng cấu của nhóm $G$.
]

#cau[
  *Câu 4 (2.0 điểm).* Cho $H, K$ là hai nhóm con chuẩn tắc của $(G, dot)$ thỏa mãn $H inter K = brace.l e brace.r$.

  Chứng minh rằng $x y = y x$, với mọi $x in H$, $y in K$.
]

#cau[
  *Câu 5 (Thưởng +1.0 điểm).* Cho một ví dụ về một nhóm $G$ có cấp vô hạn nhưng tất cả phần tử của $G$ đều có cấp hữu hạn.
]
#loigiai[

  *Câu 1*

  *a)* Đóng : Lấy $x,y in G$, có 
  $
x*y=x+y+3 x y=x(1+3 y)+1/3(1+3y) -1/3=(x+1/3)(1+3 y)-1/3=3(x+1/3)(y+1/3)-1/3=> 1/9+1/3x*y=(x+1/3)(y+1/3)
  $
  Do đó, nếu $x*y=-1/3$, thì dẫn đến $x=-1/3 or y=-1/3$, vô lý. Vậy , $x*y in G$.

  Kết hợp : Lấy $x,y,z in G$, có 
  $
(x*y)*z=(x*y)+z+3 (x*y)z= x+y+3 x y+z +(x +y +3 x y) z= x*(y*z)
  $

  Giao hoán : Lấy $x,y in G$, có $x*y=x+y+3 x y= y + x + 3 y x= y*x$, do đó $G$ giao hoán.

  Đơn vị : Tìm $e in G$, thỏa $forall x in G$, $x * e= e*x =x$, giả sử có $e in G$ thỏa điều trên, ta có 
  $
x*e=x+e+3 x e= x <=> e (1+3 x)=0 => e=0 "vì "x!=-1/3
  $

  Khả nghịch : Lấy bất kỳ $x in G$, tìm $y in G$ sao cho $x *y=e$

  Có $
x*y=x+y+3 x y =0 <=> y(1+3 x) =- x => y= -x/(1+3 x) in G 
  $

  *b)* Ta có nhận xét :
  $
1/9+1/3 x^*(m)=(x+1/3)^m
  $
  Do đó, nếu $x^(*m)=0 => (x+1/3)^m=1$, do đó nếu $m$ chẵn thì $x+1/3=+-1 =>x=-2/3 "hoặc" x=2/3$.

  *Câu 3*

  *a)* Xét $(G,.)$ là nhóm có cấp $13$, ta chứng minh $G$ là nhóm cyclic. Vì $G$ là nhóm có cấp $13$, do đó ta lấy $a in G : a !=e$.

  Theo định lý Largange, đặt $m=o r d(a) => m | 13$, mặt khác $a !=e => m !=1$, mà $13$ là số nguyên tố , nên $m | 13 " và " m!=1 => m=13$. Do đó, cấp $a=13 => G=chevron.l a chevron.r$

  *b)* 

  *Đồng Cấu* Lấy $x,y in G$, có 
  $
  f(x y)=(x y)^8=x^8 y^8=f(x) f(y) "Do G là nhóm cyclic, nên G đặc biệt abel".

  $
  Do đó, $f$ là đồng cấu nhóm.

  Đơn ánh : Lấy tùy ý $x,y in G$, giả sử $f(x)=f(y) <=> x^8=y^8 => x= y?$, $x=a^m,y=a^n$. Có 
  $
x^8=(a^m)^8=(a^n)^8=y^8 <=> (a^8)^m=(a^8)^n => m=n => x=y 

  $

  Chứng minh : $K e r f ={e}$. Lấy $x in K e r f =>? x in {e}$. Có $x in K e r f <=> f(x)=e <=> x^8 = e$, mặt khác vì $x in G$,
  nên có $m in ZZ$ sao cho $x=a^m => a^(m)^8=e=a^0=> 8 m =0 => m=0 => x= e => x in {e}$.


  *Câu 4* 

  Cần chứng minh  : $x y= y x,forall x in H ,forall y in K $.

  Mục tiêu của mình là : $x y = y x =>a=y^(-1) x y x^(-1)=e => y^(-1) x y  x^(-1) in H inter K $.

  H là nhóm con chuẩn tắc, K là nhóm con chuẩn tắc.

  *Câu 3*

  Cho $(G,+)$ là một nhóm cộng cấp $20$. Với mỗi $a | 20$. Định nghĩa 
  $
G_a :={g in G : |g| | a}
  $

  *a)* CMR : $G_4$ và $G_5$ là $2$ nhóm con của $(G,+)$, và $G_4 inter G_5={0}$.
  
  *b)* CMR : $G=G_4+G_5$.

  *a)* Quy ước nhóm cộng là nhóm abel. 

  Lấy tùy ý $0 in G : |0|=1 | 4 => 0 in G_4$. Vậy $G_4 != emptyset$. 

  Lấy tùy ý $x,y in G_4$, chứng minh $x+y in G_4$, hay $ o r d (x+y) | 4$

  Từ $x,y in G_4 => o r d (x) | 4  quad"và"   o r d (y) | 4$, Có $(x+y)^4=x+y+x+y+x+y+x+y=4 x + 4 y=0 => o r d (x+y ) | 4 => (x+y) in G_4$.

  Lấy $x in G_4$, chứng minh $x^(-1) in G_4$. Luôn có $|x|=|x^(-1)| => |x^(-1)| | 4 "do "|x| | 4$. Vậy $G_4$ là nhóm con của $G$, chứng minh tương tự với $G_5$.  Chứng minh $G_4 inter G_5={0}$.

  Lấy $
  x in G_4 inter G_5 => cases(o r d(x) | 4 , o r d (x) | 5 )
  => cases(4 x =0,5 x =0) => x=0 => x in {0} => G_4 inter G_5 subset.eq {0}. $

  *3b)*

  Chứng minh $G=G_4+G_5$. 


  Nhận xét : 

  $G_4 + G_5 subset.eq G$. Vì $G_4$ và $G_5$ là nhóm con của $G$, mặt khác $G$ là nhóm, nên sẽ đóng với phép cộng, vậy $G_4 + G_5 subset.eq G$.

  $G subset.eq G_4 +G_5$. Trong đó, $G_4+G_5 ={g_1 + g_2 : g_1 in G_4, g_2 in G_5}$.

  Lấy $g in G => |g| | 20$. Mặt khác, nếu $|g| | 5 => g in G_5 ; |g| | 4 => g in G_4$.

  $g=5 g+(-4)g$. Trong đó, $5 g in G_4$. Đặt $x= 5g => 4 x = 20 g=0=> x in G_4$, tương tự $y=-4 g=> y in G_5$.

  Vậy với tùy ý $g in G$, ta đều có $g=x+y$, trong đó $x in G_4$ và $y in G_5$. Vậy $G subset.eq G_4+G_5$.
  




]
#cau[
  Cho $G, G'$ là các nhóm, $f: G -> G'$ là một toàn cấu nhóm và $H$ là nhóm con chuẩn tắc của $G$. Đặt

  $ f(H) = {f(h) | h in H}. $

  Chứng minh rằng $f(H)$ là nhóm con chuẩn tắc của $G'$.
]
#loigiai[

  Xuất phát từ điều cần chứng minh.

  $f(H)={f(h): h in H}$. // 

  $I m f={f(x) : x in G}$.

  Ảnh thật sự $f$ với tập nguồn là $G$. $f$ toàn ánh thì $I m f=G'$.

  Ảnh thật sự của tập nguồn là H.

  *f(H)* là nhóm con.

  Xét $e in H$, có $f(e)=e' in f(H) => f(H) "khác rỗng"$.

  Cho trước $x,y in f(H) $, chứng minh $x y in f(H)$.

  Cần chứng minh $x y in f(H)$, có nghĩa là tìm $h' in H : f(h')= x y$.

  $x in f(H)$, có nghĩa là có $h_1 in H : f(h_1)=x$. Tương tự, có $h_2 in H : f(h_2)=y$.

  Có $x y = f(h_1) f(h_2)= f(h_1 h_2)$ mà tại sao $h_1 h_2 in H$, vì $H$ là nhóm con chuẩn tắc của $G$, nên $h_1 h_2 in H$ do đó chọn $h'=h_1 h_2 in H$, thì $x y in f(H)$.


  Cho trước $x in f(H)$, cần chứng minh $x^(-1) in f (H)$. Hay tìm $h' in H : f(h')=x^(-1)$.

  Vì $x in f(H) => h_1 in H : f(h_1)=x => f(h_1)^(-1)=x^(-1) => f(h_1^(-1))=x^(-1)$, vì $h_1 in H =>h_1^(-1) in H$, do đó chọn $h'=h_1^(-1)$ thì $x^(-1) in f(H)$.

  Vậy, $f(H) <= G'$.

  Chứng minh $f(H)$ là nhóm con chuẩn tắc của $G'$.

  Cho trước $g in G'$ và $x in f(H)$, ta chứng minh $g x g^(-1) in f(H)$.
  Tức là tìm $h' in H : f(h')=g x g^(-1)$.


Vì $x in f(H) => "có" h_1 in H : f(h_1)=x$, nếu $g in G'$, có tìm được $k in G:f(k)=g$? 

Vì $f$ là toàn cấu nhóm, nên với mỗi $g in G'$, ta đều tìm được $k in G : f(k)=g$, khi đó với $g^(-1)$, ta tìm được $k^(-1) in G : f(k^(-1))=g^(-1)$.

Khi đó, $g x g^(-1)= f(k) f(h_1) f(k^(-1))=f(k h_1 k^(-1))$, làm sao chỉ ra $k h_1 k^(-1) in H$.

Vì $H$ là nhóm con chuẩn tắc của $G$, nên $k h_1 k^(-1) in H$, do đó chọn $h'=k h_1 k^(-1) in H$.
  

]




