<br>
<div align="center">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
</div>
<br>

<p align="center">
<strong>Idioma:</strong>
Português | <a href="README.md">English</a>
</p>

<h1 align="center">Gerenciamento de Resultados em Flutter</h1>

<p align="center">
Arquitetura simples e extensível para lidar com resultados em aplicações Flutter, baseada no conceito de <strong>Result</strong> (sucesso ou falha).
<br>
<a href="#sobre-o-projeto"><strong>Explore a documentação »</strong></a>
</p>

## Sumário

- [Sobre o Projeto](#sobre-o-projeto)
- [O Problema](#o-problema)
- [Objetivos](#objetivos)
- [Conceitos Fundamentais](#conceitos-fundamentais)
- [Tratamento de Resultados](#tratamento-de-resultados)
- [Estratégia de Tratamento de Erros](#estratégia-de-tratamento-de-erros)
- [Licença](#licença)
- [Autor](#autor)

</br>

## Sobre o Projeto

Este projeto visa demonstrar uma abordagem clara e previsível para o gerenciamento de resultados em aplicações Flutter, utilizando uma abstração baseada em `Result`, adaptada à realidade do Flutter e ao uso frequente de operações assíncronas e feedbacks de interface.

O foco da arquitetura não é apenas reduzir código, mas tornar o fluxo de sucesso e falha explícito, previsível, fácil de entender e simples de manter, mesmo em aplicações de médio e grande porte.

</br>

## O Problema

Em qualquer aplicação é comum lidar com operações que podem falhar.  
Sem uma abordagem padronizada, o código frequentemente se torna repetitivo, difícil de entender e manter, e apresenta inconsistências no tratamento de falhas.

Alguns problemas recorrentes incluem:

- Uso excessivo de `try/catch`
- Tratamento inconsistente de erros
- Fluxos de execução imprevisíveis
- Verificações constantes de `null`
- Dificuldade de manutenção e escalabilidade em aplicações maiores

A ausência de padronização dificulta a leitura do código e aumenta o risco de erros não tratados ou comportamento inesperado.

</br>

## Objetivos

Para resolver os principais problemas, a arquitetura tem como objetivos:

- Padronizar o retorno de operações assíncronas
- Evitar o uso excessivo de `try/catch`
- Tornar o fluxo de erro previsível e controlável
- Facilitar o tratamento local de erros específicos
- Melhorar a legibilidade e a manutenibilidade do código

A proposta não substitui exceções internas, mas fornece uma camada semântica clara para o gerenciamento de resultados na aplicação.

</br>

## Conceitos Fundamentais

### Result

`Result<T>` representa o resultado de uma operação e pode assumir dois estados:

- `SuccessResult<T>`: operação executada com sucesso
- `FailureResult<T>`: operação falhou por algum motivo

Essa separação elimina a necessidade de verificar valores nulos ou capturar exceções no ponto de uso.

### Failure

`Failure` representa falhas conhecidas, previstas e tratáveis pela aplicação.

Ela constitui a base do modelo de erros do domínio e não deve ser instanciada diretamente.

Todo erro que a aplicação reconhece e sabe tratar deve ser modelado como um subtipo de `Failure`.

### Sealed Class

`Failure` é definida como uma `sealed class`, garantindo que todas as falhas possíveis estejam explicitamente controladas pelo domínio da aplicação.

```dart
sealed class Failure {}
```

Benefícios:

- Garantia de exaustividade no tratamento de falhas
- Maior previsibilidade do fluxo de erro
- Clareza e identificação explícita do motivo da falha

### Implementações Concretas de Failure

Cada falha deve ser representada por uma classe concreta que estende `Failure`.

Essas classes podem conter:

- Tipo do erro (`FailureType`)
- Mensagem amigável
- Dados adicionais para logs ou métricas

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

#### Quando criar uma nova Failure

Crie uma nova `Failure` quando:

- O erro é conhecido e esperado
- Existe uma ação clara associada ao erro
- O erro faz parte das regras do domínio

Exemplos comuns:

- Falha de API (`ApiFailure`)
- Falha de Validação (`ValidationFailure`)
- Falha de Cache (`CacheFailure`)
- Falha de Autenticação (`AuthFailure`)
- Falha de Processamento de Dados (`ParsingFailure`)

Objetivo do modelo:

- Centralizar e padronizar falhas
- Priorizar clareza e previsibilidade

</br>

## Tratamento de Resultados

A API disponibiliza métodos distintos para dois tipos de necessidade (podendo ser expandido):

1. Produção de valor a partir do resultado.
2. Execução de efeitos colaterais.

A diferença conceitual central é:

- `fold` e `foldAsync` retornam um valor.
- `when` e `whenAsync` não retornam valor.

A escolha entre as versões síncronas e assíncronas depende exclusivamente da necessidade de utilizar `await` nos callbacks.

</br>

## Métodos que Retornam Valor

Devem ser utilizados quando o fluxo precisa transformar o `Result` em um valor.

### fold (Síncrono)

Executa callbacks síncronos e retorna um valor.

```dart
final value = result.fold(
  onSuccess: (data) => data,
  onFailure: (failure) => null,
);
```

Indicado quando toda a lógica pode ser executada de forma síncrona.

### foldAsync (Assíncrono)

Executa callbacks assíncronos e retorna um `Future<T>`.

```dart
final value = await result.foldAsync(
  onSuccess: (data) async => data,
  onFailure: (failure) async => null,
);
```

Deve ser utilizado quando pelo menos um dos callbacks precisa realizar operações assíncronas.

</br>

## Métodos para Efeitos Colaterais

Devem ser utilizados quando o objetivo é executar ações sem produzir valor.

Exemplos comuns:

- Atualização de estado
- Exibição de mensagens
- Navegação
- Execução de comandos adicionais

### when (Síncrono)

Executa callbacks síncronos e não retorna valor.

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

Indicado quando nenhuma operação assíncrona é necessária.

### whenAsync (Assíncrono)

Executa callbacks assíncronos e retorna `Future<void>`.

```dart
await result.whenAsync(
  onFailure: (failure) async {
    // Exibição de diálogo, navegação, etc.
  },
);
```

Deve ser utilizado quando o fluxo exige operações assíncronas, como chamadas adicionais, navegação ou exibição de diálogos.

</br>

## Estratégia de Tratamento de Erros

A arquitetura suporta dois níveis de tratamento de falhas: local e global.

### Tratamento Local

O tratamento local deve ser utilizado quando o contexto atual da aplicação possui uma resposta específica para determinada falha.  
Ele permite que a ação corretiva seja tomada diretamente no ponto em que o erro ocorre.

Exemplo de implementação de tratamento de falha local:

```dart
await result.whenAsync(
  onFailure: (failure) async {
    switch (failure) {
      case ApiFailure():
        // Exemplo de tratamento específico
        break;
    }
  },
);
```

Neste exemplo, o código demonstra como uma falha pode ser capturada e tratada de forma contextual, permitindo ações específicas como:

- Atualização do estado da tela
- Exibição de mensagens ou diálogos customizados
- Redirecionamento ou retry de operações

### Tratamento Global

O tratamento global atua como um **fallback** para falhas que não possuem tratamento específico no contexto local ou não são conhecidas.
Ele garante que qualquer erro inesperado ou não tratado receba uma resposta consistente da aplicação, mantendo previsibilidade e padronização na interface.

A lógica principal do manipulador global consiste em:

- Receber a falha não tratada localmente
- Identificar o tipo da falha
- Traduzir a falha em uma mensagem compreensível para o usuário
- Exibir feedback visual padrão, como diálogos, alertas ou snackbars
- Evitar decisões de regra de negócio; o domínio continua isolado da apresentação

Dessa forma, qualquer operação que falhar sem tratamento local ainda terá um tratamento previsível e uniforme em toda a aplicação.

#### Exemplo

```dart
Future<void> handleError(BuildContext context, Failure failure) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Erro'),
        content: Text(failure.message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
```

O manipulador global deve ser acionado quando uma falha não for totalmente tratada no nível local, da seguinte forma:

```dart
await result.whenAsync(
  onFailure: (failure) async {
    switch (failure) {
      case ApiFailure():
        // Tratamento local
        break;
      default:
        await handleError(context, failure);
    }
  },
);
```

Nesse fluxo:

- A falha é analisada no contexto local.
- Caso exista uma regra específica, ela é executada.
- Caso contrário, a falha é delegada ao manipulador global.
- O manipulador global garante feedback consistente sem duplicação de lógica.

</br>

## Licença

Distribuído sob a Licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais informações.

</br>

## Autor

Desenvolvido por **Dário Matias**:

- Portfolio: [https://dariomatias-dev.com](https://dariomatias-dev.com)
- GitHub: [https://github.com/dariomatias-dev](https://github.com/dariomatias-dev)
- Email: [matiasdario75@gmail.com](mailto:matiasdario75@gmail.com)
- Instagram: [https://instagram.com/dariomatias_dev](https://instagram.com/dariomatias_dev)
- LinkedIn: [https://linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)
