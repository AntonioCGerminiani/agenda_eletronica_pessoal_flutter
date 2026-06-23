enum ContactSortOption {
  // Cada opção funciona como uma instância do próprio enum então,
  // ao fornecer "('string genérica')" para cada um, inicializo o construtor
  // com a tal string como parâmetro.
  nameAsc('Nome (A-Z)'),
  nameDesc('Nome (Z-A)'),
  createdAtAsc('Data de criação (Crescente)'),
  createdAtDesc('Data de criação (Decrescente)'),
  lastUpdateAsc('Última atualização (Crescente)'),
  lastUpdateDesc('Última atualização (Decrescente)');

  // Aqui se define a variável que receberá o valor da string parâmetro
  final String label;

  // Aqui se atribui o valor do parâmetro para a variável "label".
  const ContactSortOption(this.label);
}
