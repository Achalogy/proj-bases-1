import { readFileSync } from 'fs'

console.log(
  readFileSync('meta.txt', 'utf-8').split("\r\n").map(x => {
    let year = "202" + Math.floor((Math.random() * 3) + 1);
    let month = ("" + Math.floor((Math.random() * 6) + 1)).padStart(2, "0");
    let day = ("" + Math.floor((Math.random() * 27) + 1)).padStart(2, "0");

    let b = x.split(/[\(\)]/g)
    let a = b.at(3).split(", ")
    a[0] = year+month+day
    b[3] = a.join(", ");

    console.log(b)

    return (b[0] + "(" + b[1] + ")" + b[2] + "(" + b[3] + ")" + b[4]);
  }).join("\r\n")
)