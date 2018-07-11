import Welcome from "welcome";


describe('Welcome', () => {
    it('has a created hook', () => {
        expect(typeof Welcome.methods.createChat).toBe('function')
    })
})