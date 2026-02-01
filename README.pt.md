<br>
<div align="center">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
</div>
<br>

<h1 align="center">Gerenciamento de Resultados em Flutter</h1>

<p align="center">
Solução customizada, simples e extensível para lidar com resultados em aplicações Flutter, baseada no conceito de <strong>Result</strong> (sucesso ou falha).
<br>
<a href="#sobre-o-projeto"><strong>Explore a documentação »</strong></a>
</p>

## Sumário

- [Sobre o Projeto](#sobre-o-projeto)
- [Objetivo da Solução](#objetivo-da-solução)
- [Conceitos Principais](#conceitos-principais)
- [Configuração de Requisições](#configuração-de-requisições)
- [Tratamento de Resultados](#tratamento-de-resultados)
- [Tratamento Local vs Global](#tratamento-local-vs-global)
- [Licença](#licença)
- [Autor](#autor)

## Sobre o Projeto

Este projeto propõe uma abordagem clara e previsível para o gerenciamento de resultados em aplicações Flutter, utilizando uma abstração própria baseada em `Result`, inspirada no conceito de `Either`, porém adaptada à realidade do Flutter e ao uso intenso de operações assíncronas e feedbacks de interface.

O foco da solução não é eliminar código, mas tornar o fluxo de sucesso e falha explícito, fácil de entender e simples de manter, mesmo em aplicações de médio e grande porte.

## Objetivo da Solução

O principal objetivo desta solução é:

- Padronizar o retorno de operações assíncronas
- Evitar o uso excessivo de `try/catch`
- Tornar o fluxo de erro previsível e controlável
- Facilitar o tratamento local de erros específicos
- Melhorar a legibilidade e a manutenibilidade do código

A solução não substitui exceções internas, mas fornece uma camada semântica clara para o consumo de resultados na aplicação.

## Conceitos Principais

### Result

`Result<T>` representa o resultado de uma operação e pode assumir dois estados:

- `SuccessResult<T>`: operação executada com sucesso
- `FailureResult<T>`: operação falhou por algum motivo

Essa separação elimina a necessidade de verificar valores nulos ou capturar exceções no ponto de uso.

### Failure

`Failure` representa falhas **conhecidas, previstas e tratáveis** pela aplicação.
Ela constitui a base do modelo de erros do domínio e **não deve ser instanciada diretamente**.

Todo erro que a aplicação reconhece e sabe tratar deve ser modelado como um subtipo de `Failure`.

#### Sealed class

`Failure` é definida como uma **`sealed class`**, garantindo que **todas as falhas possíveis estejam explicitamente controladas pelo domínio da aplicação**.

```dart
sealed class Failure {}
```

Essa abordagem oferece:

- Garantia de exaustividade no tratamento de falhas
- Maior previsibilidade do fluxo de erro
- Clareza e documentação implícita do domínio de erros

#### Criação de falhas customizáveis

Cada falha deve ser representada por uma **classe concreta**, estendendo `Failure`.
Essas classes podem carregar informações específicas, tais como:

- Tipo do erro (`FailureType`)
- Mensagem amigável para exibição ao usuário
- Dados adicionais para tomada de decisão, logs ou métricas

Exemplo:

```dart
final class ApiFailure extends Failure {
  final FailureType type;
  final String message;

  ApiFailure({
    required this.type,
    required this.message,
  });
}
```

#### Quando criar uma nova `Failure`

Uma nova implementação de `Failure` deve ser criada quando:

- O erro é conhecido e esperado
- Existe uma ação clara associada ao erro
- O erro faz parte das regras do domínio da aplicação

Exemplos comuns incluem:

- `ApiFailure`
- `ValidationFailure`
- `CacheFailure`

#### Objetivo do modelo

O uso de `Failure` tem como objetivos:

- Centralizar e padronizar o tratamento de falhas
- Priorizar legibilidade, clareza e previsibilidade do código

## Configuração de Requisições

### Definição de URLs

As URLs base utilizadas pelas requisições devem ser definidas separadamente:

```dart
class Urls {
  static const httpUrl = 'https://dummyjson.com/http';
}
```

### Serviço de API

O serviço responsável pelas requisições HTTP encapsula a URL base:

```dart
class ApiService {
  static ApiMethods get http => ApiMethods(
        baseUrl: Urls.httpUrl,
      );
}
```

### Criando uma Instância

```dart
final _api = ApiService.http;
```

### Realizando Requisições

Requisição simples:

```dart
final result = await _api.get('[path]');
```

Com headers:

```dart
final result = await _api.get(
  '[path]',
  headers: <String, dynamic>{},
);
```

Com body:

```dart
final result = await _api.post(
  '[path]',
  headers: <String, dynamic>{},
  data: <String, dynamic>{},
);
```

## Tratamento de Resultados

### fold

Utilizado quando é necessário **retornar um valor** a partir do resultado:

```dart
final value = result.fold(
  onSuccess: (data) => data,
  onFailure: (failure) => null,
);
```

### when

Utilizado para **efeitos colaterais síncronos**, como alteração de estado:

```dart
result.when(
  onSuccess: (value) {
    // Atualização de estado
  },
  onFailure: (failure) {
    // Tratamento síncrono
  },
);
```

### whenAsync

Utilizado para **efeitos colaterais assíncronos**, como exibição de diálogos, navegação ou chamadas adicionais:

```dart
await result.whenAsync(
  onFailure: (failure) async {
    // Feedback visual ou navegação
  },
);
```

A separação entre `when` e `whenAsync` é intencional e visa evitar ambiguidades relacionadas a `FutureOr`, tornando o fluxo explícito e previsível.

## Tratamento Local vs Global

A solução permite tratar erros de forma local sempre que necessário, mantendo o controle no ponto onde a ação ocorre e permitindo respostas específicas ao contexto da tela ou fluxo.

### Tratamento Local

O tratamento local deve ser utilizado quando a tela ou fluxo possui uma resposta específica para determinado erro.

```dart
await result.whenAsync(
  onFailure: (failure) async {
    switch (failure) {
      case ApiFailure():
        // Tratamento local específico
        break;
    }
  },
);
```

Esse tipo de tratamento é indicado quando:

- A ação corretiva é conhecida naquele contexto
- O feedback ao usuário depende da tela atual
- O erro exige uma interação específica (ex.: diálogo, redirecionamento, retry)

## Manipulador Global de Erros

Quando não existe um tratamento específico no contexto atual, a falha deve ser delegada para um **manipulador global**.

```dart
await handleError(context, failure);
```

O manipulador global é responsável por:

- Fornecer um feedback padrão e consistente ao usuário
- Centralizar a apresentação de erros não tratados localmente
- Evitar duplicação de lógica entre telas
- Garantir uma experiência uniforme em toda a aplicação

Esse mecanismo atua como **fallback**, sendo acionado apenas quando a falha não é resolvida no nível local.

### Responsabilidade do manipulador global

O manipulador global **não decide regras de negócio**.
Sua responsabilidade é exclusivamente:

- Traduzir falhas em mensagens compreensíveis
- Exibir alertas, dialogs, snackbars ou telas de erro
- Manter a padronização visual e comportamental do feedback

Dessa forma, o domínio continua isolado da camada de apresentação, enquanto a interface permanece clara, previsível e consistente.

## Licença

Distribuído sob a **Licença MIT**. Veja o arquivo [LICENSE](LICENSE) para mais informações.

## Autor

Desenvolvido por **Dário Matias**:

- **Portfolio**: [https://dariomatias-dev.com](https://dariomatias-dev.com)
- **GitHub**: [https://github.com/dariomatias-dev](https://github.com/dariomatias-dev)
- **Email**: [matiasdario75@gmail.com](mailto:matiasdario75@gmail.com)
- **Instagram**: [https://instagram.com/dariomatias_dev](https://instagram.com/dariomatias_dev)
- **LinkedIn**: [https://linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)
