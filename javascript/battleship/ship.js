export class Ship {
  constructor({id: id, length: length, x: x, y: y, rot: rot}) {
    this.id = id
    this.length = length
    this.x = x
    this.y = y
    this.rot = rot
    this.positions = this.calculatePositions()
    this.hits = []
  }

  calculatePositions() {
    let positions = []

    for(let pos = 0; pos < this.length; pos++){
      if(this.rot === 0){
        positions.push({x: this.x + pos, y: this.y})
      }else {
        positions.push({x: this.x, y: this.y + pos})
      }
    }
    return positions
  }

  hit({x: x, y: y}) {
    const coords = {x: x, y: y}
    if(!this.positions.find(pos => pos.x === x && pos.y === y)) throw "missed"

    if(this.hits.find(pos => pos.x === x && pos.y === y)) {throw "already hit"}

    this.hits.push(coords)
  }

  isSunk() {
    return this.hits.length === this.length
  }


}