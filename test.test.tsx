describe('operations', function() {
	describe('#indexOf()', function() {
		it('add', async function() {
			assert.equal(1 + 1, 2);
		});
		it('minus', function() {
			assert.equal(2 - 1, 1);
		});
	});
	describe('#fail', function() {
		it('add 2', function() {
			assert.equal(2 + 1, 2);
		});
		it('minus 2', function() {
			assert.equal(3 - 1, 1);
		});
	});
});
