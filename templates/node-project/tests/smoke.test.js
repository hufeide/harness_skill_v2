const test = require("node:test");
const assert = require("node:assert/strict");

const { add } = require("../src/index");

test("add adds numbers", () => {
  assert.equal(add(1, 2), 3);
});


