const DIV_PACK_1 = [[2]];
const DIV_PACK_2 = [[6]];

function compare(packet1, packet2) {
    if (typeof packet1 === "object" && typeof packet2 === "object") {
        let index = 0;
        for (el of packet1) {
            if (index >= packet2.length) {
                // packet 2 ran out first
                return 1;
            }

            let res = compare(el, packet2[index]);
            if (res !== 0) {
                return res;
            }
            index += 1;
        }
        if (index < packet2.length) {
            // packet 1 ran out first
            return -1;
        }

        return 0;
    } else if (typeof packet1 === "number" && typeof packet2 === "number") {
        return packet1 < packet2 ? -1 : packet1 === packet2 ? 0 : 1;
    } else {
        if (typeof packet1 === "number") {
            return compare([packet1], packet2);
        } else {
            return compare(packet1, [packet2]);
        }
    }
}

let inputText = INPUT_TEXT.replace("\r", ""); 
let packets = inputText.split("\n")
        .filter(s => s !== "")
        .map(s => JSON.parse(s));

let sum = 0;

let ordinal = 1;
for (let i = 0; i < packets.length; i += 2) {
    let packet1 = packets[i];
    let packet2 = packets[i + 1];

    if (compare(packet1, packet2) === -1) {
        sum += ordinal;
    }

    ordinal += 1;
}

// make a deep copy
let packetsB = packets.map(p => JSON.parse(JSON.stringify(p)));
packetsB.push(DIV_PACK_1);
packetsB.push(DIV_PACK_2);
packetsB.sort(compare);

let div1Ordinal = packetsB.indexOf(DIV_PACK_1) + 1;
let div2Ordinal = packetsB.indexOf(DIV_PACK_2) + 1;
let divProduct = div1Ordinal * div2Ordinal;
packetsB.forEach(p => console.log(JSON.stringify(p)));

document.getElementById("answerA").innerText = sum;
document.getElementById("answerB").innerText = divProduct;
