describe('logintest', () => {
  beforeEach(() => {
    cy.visit('www.bortube.nl')
  })

  it('error on wrong creds', () => {
    /* ==== Generated with Cypress Studio ==== */
    cy.get('#flt-semantic-node-7', {timeout: 15000}).click();
    cy.get('#email').clear();
    cy.get('#email').type('cypress@test.com');
    cy.get('[aria-label="Password"]').clear();
    cy.get('[aria-label="Password"]').type('wrongpassword{enter}');
    /* ==== End Cypress Studio ==== */

     // Wait for the page to load:
     cy.wait(2500);

     // Check if the user is logged in:
      // Check the inside of the semantic node 7 element:
      cy.get('#flt-semantic-node-7').should('have.text', 'Login');
  });

  it('can login', () => {
    /* ==== Generated with Cypress Studio ==== */
    cy.get('#flt-semantic-node-7', {timeout: 15000}).click();
    cy.get('#email').clear();
    cy.get('#email').type('cypress@test.com');
    // Get input by aria-label:
    cy.get('[aria-label="Password"]').clear();
    cy.get('[aria-label="Password"]').type('cypresstest{enter}');
    /* ==== End Cypress Studio ==== */

    // Wait for the page to load:
    cy.wait(2500);

    // Check if the user is logged in:
    //  cy.get('#flt-semantic-node-7').should('have.attr', 'aria-label', 'cypress');
     // Check the inside:
      cy.get('#flt-semantic-node-7').should('have.text', 'cypress');

  });

  it('can logout', () => {
    // Start by logging in
    cy.get('#flt-semantic-node-7', {timeout: 15000}).click();
    cy.get('#email').clear();
    cy.get('#email').type('cypress@test.com');
    cy.get('[aria-label="Password"]').clear();
    cy.get('[aria-label="Password"]').type('cypresstest{enter}');

    // Click logout
    cy.get('#flt-semantic-node-25').click();
    // Wait for the page to load:

    cy.wait(2500);

    // Check if the user is logged in:
    //  cy.get('#flt-semantic-node-7').should('have.attr', 'aria-label', 'Login');
     // Check the inside:
      cy.get('#flt-semantic-node-7').should('have.text', 'Login');

  })
})