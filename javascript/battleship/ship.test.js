import {describe, expect, test} from '@jest/globals'
import * as shipFactory from "./ship.js"

describe("Ship", () => {
  describe("when rot is 0", () => {
    let ship
    beforeEach(() => {ship = new shipFactory.Ship({length: 4, x: 2, y: 2, rot: 0})})
    describe("calculatePositions", () => {
      test("should return [{x: 2, y: 2}, {x: 3, y: 2}, {x: 4, y: 2}, {x: 5, y: 2}]", () => {
        expect(ship.calculatePositions()).toEqual([{x: 2, y: 2}, {x: 3, y: 2}, {x: 4, y: 2}, {x: 5, y: 2}])
      })
    })
    describe("hit()", () => {
      test("when given {x: 3, y: 2} should update hits to [{x: 3, y: 2}}", () => {
        ship.hit({x: 3, y: 2})
        expect(ship.hits).toEqual([{x: 3, y: 2}])
      })
      test("when position is already hit should throw error 'already hit'", () => {
        ship.hit({x: 3, y: 2})
        expect(() => {ship.hit({x: 3, y: 2})}).toThrow('already hit')
      })
      test("when given coords not in positions should throw error 'missed'", () => {
        expect(() => {ship.hit({x: 6, y: 2})}).toThrow('missed')
      })
    })
  })
  describe("when rot is 1", () => {
    let ship
    beforeEach(() => {ship = new shipFactory.Ship({length: 4, x: 2, y: 2, rot: 1})})
    describe("calculatePositions", () => {
      test("should return [{x: 2, y: 2}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 2, y: 5}]", () => {
        expect(ship.calculatePositions()).toEqual([{x: 2, y: 2}, {x: 2, y: 3}, {x: 2, y: 4}, {x: 2, y: 5}])
      })
    })
    describe("isSunk()", () => {
      test("when all positions are hit should return true", () => {
        ship.hit({x: 2, y: 2})
        ship.hit({x: 2, y: 3})
        ship.hit({x: 2, y: 4})
        ship.hit({x: 2, y: 5})
        expect(ship.isSunk()).toBe(true)
      })
      test("when some positions are hit should return false", () => {
        ship.hit({x: 2, y: 2})
        ship.hit({x: 2, y: 5})
        expect(ship.isSunk()).toBe(false)
      })
    })
  })
})

