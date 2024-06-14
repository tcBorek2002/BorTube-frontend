describe('getvideos', () => {
  beforeEach(() => {
    cy.visit('www.bortube.nl')
  })

  it('Videos should display', () => {
    // get all flt-semantics elements
    let semantics = cy.get('flt-semantics', {timeout: 15000});
    // check if the elements are more than 0
    semantics.should('have.length.greaterThan', 0);    
  });

})