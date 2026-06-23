enum EventSortOption {
  // Cada opção funciona como uma instância do próprio enum então,
  // ao fornecer "('string genérica')" para cada um, inicializo o construtor
  // com a tal string como parâmetro.
  eventDateAsc('Data do Evento (Crescente)'),
  eventDateDesc('Data do Evento (Decrescente)'),
  futureEvents('Eventos Futuros'),
  pastEvents('Eventos Passados');

  // Aqui se define a variável que receberá o valor da string parâmetro
  final String label;

  // Aqui se atribui o valor do parâmetro para a variável "label"
  const EventSortOption(this.label);
}
