# Erros e troubleshooting em Fastify

Consulte este arquivo sempre que o usuário colar um stack trace, um código
`FST_ERR_*`, um comportamento inesperado (rota não encontrada, plugin que não
carrega, decorator "sumindo") ou pedir para investigar um bug em produção.

## Como o Fastify trata erros por padrão

- Erros síncronos e `async` lançados dentro de rotas são capturados
  automaticamente e roteados para o error handler padrão → `500 Internal
  Server Error`.
- O handler padrão serializa o erro em JSON com **apenas** `statusCode`,
  `error`, `message` (e `code`, se o erro tiver um). O `stack` **não** é
  incluído por padrão.
- **Ponto crítico de segurança**: `message` é `error.message` **verbatim** —
  Fastify não distingue dev/produção. Um erro de driver de banco, por exemplo,
  pode vazar nome de coluna/schema/query direto para o cliente:

```json
{
  "statusCode": 500,
  "code": "ER_BAD_FIELD_ERROR",
  "error": "Internal Server Error",
  "message": "Unknown column 'username' in 'field list'"
}
```

  Se isso for um problema (normalmente é, em produção), a correção é
  registrar um `setErrorHandler` custom:

```js
app.setErrorHandler(function (error, request, reply) {
  // erros com statusCode < 500 (ou de validação) foram levantados de propósito
  if (error.validation || (error.statusCode && error.statusCode < 500)) {
    return reply.send(error)
  }
  // qualquer outra coisa é inesperada: logue, mas não descreva ao cliente
  this.log.error({ err: error }, 'unhandled error')
  reply.status(500).send({
    statusCode: 500,
    error: 'Internal Server Error',
    message: 'Internal Server Error'
  })
})
```

- Um schema de resposta a nível de rota ainda é aplicado ao que o error
  handler enviar, e pode reformatar o payload — incluindo campos que o
  serializador padrão omitiria (como `stack`), se o schema declarar isso.

## Encapsulamento de error handlers

- `setErrorHandler` é encapsulado como qualquer outra coisa em Fastify: se
  chamado dentro de um `register`, só vale para aquele plugin e seus filhos.
- Se um error handler de plugin filho relança (`throw`) um erro que **não** é
  instância de `Error` (ex.: `throw 'foo'`), ele **não propaga** para o
  handler do contexto pai — cai direto no handler padrão do Fastify. Sempre
  use `throw new Error('mensagem')`, nunca `throw 'string'`.
- `onError` hook dispara uma única vez para o primeiro erro lançado — Fastify
  evita loops infinitos de erro internamente.
- Dentro do `onError`, chamar `reply.send()` lança `FST_ERR_SEND_INSIDE_ONERR`.

## Diagnóstico rápido por sintoma

| Sintoma | Causa provável | Onde olhar |
|---|---|---|
| Rota retorna 404 inesperado | Rota registrada em outro encapsulamento, ou método/URL não bate | Confirme em qual `register` a rota foi declarada; `FST_ERR_NOT_FOUND` |
| `xyz is not a function` / decorator sumiu | `decorate` feito dentro de um `register` sem `fastify-plugin`, então não vazou pro escopo pai | Ver `FST_ERR_DEC_UNDECLARED`; envolver o plugin com `fp()` |
| Plugin nunca termina de carregar / timeout no boot | `done()` (ou a Promise) nunca é chamado dentro do plugin | `FST_ERR_PLUGIN_TIMEOUT` |
| App falha ao registrar plugin de terceiro | Versão do Fastify incompatível com a exigida pelo plugin | `FST_ERR_PLUGIN_VERSION_MISMATCH` |
| Erro de validação de body/query/params | Payload não bate com o JSON Schema da rota | `FST_ERR_VALIDATION`; inspecione `error.validation` |
| Resposta 500 misteriosa sem detalhes | `setErrorHandler` custom mascarando o erro real (de propósito) | Verifique o handler; adicione log com `this.log.error({ err: error })` |
| Corpo da requisição rejeitado como grande demais | Ultrapassou o limite padrão | `FST_ERR_CTP_BODY_TOO_LARGE` → aumentar `bodyLimit` na config do server |
| Erro dizendo que Content-Type não tem parser | Tipo de conteúdo sem parser registrado | `FST_ERR_CTP_INVALID_MEDIA_TYPE` → registrar `addContentTypeParser` |
| "already registered" / rota ou schema duplicado | `$id` de schema repetido, ou mesma rota (method+path) declarada duas vezes | `FST_ERR_SCH_ALREADY_PRESENT` / `FST_ERR_DUPLICATED_ROUTE` |

## Usando `errorCodes` programaticamente

```js
import { errorCodes } from 'fastify'

fastify.setErrorHandler(function (error, request, reply) {
  if (error instanceof errorCodes.FST_ERR_BAD_STATUS_CODE) {
    this.log.error(error)
    reply.status(500).send({ ok: false })
  } else {
    reply.send(error) // deixa o handler pai (ou padrão) tratar
  }
})
```

## Tabela completa de códigos `FST_ERR_*`

| Código | Descrição | Como resolver |
|---|---|---|
| FST_ERR_NOT_FOUND | 404 Not Found | — |
| FST_ERR_OPTIONS_NOT_OBJ | Opções do Fastify mal especificadas | Options devem ser um objeto |
| FST_ERR_QSP_NOT_FN | QueryStringParser mal especificado | Deve ser uma função |
| FST_ERR_SCHEMA_CONTROLLER_BUCKET_OPT_NOT_FN | `SchemaController.bucket` mal especificado | Deve ser uma função |
| FST_ERR_SCHEMA_ERROR_FORMATTER_NOT_FN | `SchemaErrorFormatter` mal especificado | Deve ser função não-async |
| FST_ERR_AJV_CUSTOM_OPTIONS_OPT_NOT_OBJ | `ajv.customOptions` mal especificado | Deve ser um objeto |
| FST_ERR_AJV_CUSTOM_OPTIONS_OPT_NOT_ARR | `ajv.plugins` mal especificado | Deve ser um array |
| FST_ERR_CTP_ALREADY_PRESENT | Parser desse content-type já registrado | Use outro content-type ou remova o parser existente |
| FST_ERR_CTP_INVALID_TYPE | `Content-Type` mal especificado | Deve ser string |
| FST_ERR_CTP_EMPTY_TYPE | `Content-Type` vazio | Não pode ser string vazia |
| FST_ERR_CTP_INVALID_HANDLER | Handler inválido para o content-type | Use outro handler |
| FST_ERR_CTP_INVALID_PARSE_TYPE | Parse type não suportado | Aceita apenas `'string'` ou `'buffer'` |
| FST_ERR_CTP_BODY_TOO_LARGE | Corpo maior que o limite | Aumente `bodyLimit` na config do server |
| FST_ERR_CTP_INVALID_MEDIA_TYPE | Media type sem parser correspondente | Use outro content-type ou registre um parser |
| FST_ERR_CTP_INVALID_CONTENT_LENGTH | Tamanho do body não bate com `Content-Length` | Verifique o body e o header |
| FST_ERR_CTP_EMPTY_JSON_BODY | Body inválido como JSON com `content-type: application/json` | Verifique se o body é JSON válido |
| FST_ERR_CTP_INVALID_JSON_BODY | Body vazio com `content-type: application/json` | Verifique o body |
| FST_ERR_CTP_INSTANCE_ALREADY_STARTED | Fastify já foi iniciado | — |
| FST_ERR_INSTANCE_ALREADY_LISTENING | Instância já está escutando | — |
| FST_ERR_DEC_ALREADY_PRESENT | Decorator com mesmo nome já registrado | Use outro nome |
| FST_ERR_DEC_DEPENDENCY_INVALID_TYPE | Dependências do decorator devem ser `Array` | Use um array |
| FST_ERR_DEC_MISSING_DEPENDENCY | Decorator não pode ser registrado por dependência faltando | Registre a dependência faltante |
| FST_ERR_DEC_AFTER_START | Decorator adicionado depois do start | Adicione antes de iniciar o servidor |
| FST_ERR_DEC_REFERENCE_TYPE | Decorator não pode ser tipo referência | Use getter/setter ou decorator vazio + hook |
| FST_ERR_DEC_UNDECLARED | Tentativa de acessar decorator não declarado | Declare o decorator antes de usar (geralmente = falta `fastify-plugin`) |
| FST_ERR_HOOK_INVALID_TYPE | Nome do hook deve ser string | Use string |
| FST_ERR_HOOK_INVALID_HANDLER | Callback do hook deve ser função | Use função |
| FST_ERR_HOOK_INVALID_ASYNC_HANDLER | Hook async com argumento `done` a mais | Remova o `done` do hook async |
| FST_ERR_HOOK_NOT_SUPPORTED | Hook não suportado | Use um hook válido |
| FST_ERR_MISSING_MIDDLEWARE | Precisa registrar plugin de middleware | Ver referência de Middleware (`@fastify/middie`) |
| FST_ERR_HOOK_TIMEOUT | Callback de hook deu timeout | Aumente o timeout do hook |
| FST_ERR_LOG_INVALID_DESTINATION | Destino de log não aceito | Use `'stream'` ou `'file'` |
| FST_ERR_LOG_INVALID_LOGGER | Logger sem métodos obrigatórios | Precisa de `info/error/debug/fatal/warn/trace/child` |
| FST_ERR_LOG_INVALID_LOGGER_INSTANCE | `loggerInstance` recebeu config em vez de instância | Use `'logger'` para passar config |
| FST_ERR_LOG_INVALID_LOGGER_CONFIG | `logger` recebeu instância em vez de config | Use `'loggerInstance'` para passar instância |
| FST_ERR_LOG_LOGGER_AND_LOGGER_INSTANCE_PROVIDED | `logger` e `loggerInstance` juntos | Forneça apenas um |
| FST_ERR_LOG_INVALID_LOG_CONTROLLER | `logController` inválido | Deve ser instância de `LogController` |
| FST_ERR_REP_INVALID_PAYLOAD_TYPE | Payload de reply inválido | Use `string` ou `Buffer` |
| FST_ERR_REP_RESPONSE_BODY_CONSUMED | `Response` como payload já consumido | Não consuma `Response.body` antes |
| FST_ERR_REP_READABLE_STREAM_LOCKED | `ReadableStream` travado por outro reader | Não chame `getReader` antes, ou dê `releaseLock()` |
| FST_ERR_REP_ALREADY_SENT | Resposta já foi enviada | — |
| FST_ERR_REP_SENT_VALUE | `reply.sent` só aceita `true` | — |
| FST_ERR_SEND_INSIDE_ONERR | `send` usado dentro do hook `onError` | Não chame `send` nesse hook |
| FST_ERR_SEND_UNDEFINED_ERR | Erro indefinido ocorreu | — |
| FST_ERR_BAD_STATUS_CODE | Status code inválido | Use um status code válido |
| FST_ERR_BAD_TRAILER_NAME | Nome de header inválido em `reply.trailer` | Use nome válido |
| FST_ERR_BAD_TRAILER_VALUE | Tipo inválido em `reply.trailer` (esperado função) | Use uma função |
| FST_ERR_FAILED_ERROR_SERIALIZATION | Falha ao serializar um erro | — |
| FST_ERR_MISSING_SERIALIZATION_FN | Função de serialização faltando | Adicione uma |
| FST_ERR_MISSING_CONTENTTYPE_SERIALIZATION_FN | Função de serialização por content-type faltando | Adicione uma |
| FST_ERR_REQ_INVALID_VALIDATION_INVOCATION | Falta função de validação ou schema para a parte HTTP | Adicione validação |
| FST_ERR_SCH_MISSING_ID | Schema sem `$id` | Adicione `$id` |
| FST_ERR_SCH_ALREADY_PRESENT | Schema com mesmo `$id` já existe | Use `$id` diferente |
| FST_ERR_SCH_CONTENT_MISSING_SCHEMA | Falta schema para o content-type correspondente | Adicione um schema |
| FST_ERR_SCH_DUPLICATE | Schema com mesmo atributo já presente | Use atributo diferente |
| FST_ERR_SCH_VALIDATION_BUILD | JSON Schema de validação da rota é inválido | Corrija o schema |
| FST_ERR_SCH_SERIALIZATION_BUILD | JSON Schema de serialização da resposta é inválido | Corrija o schema |
| FST_ERR_SCH_RESPONSE_SCHEMA_NOT_NESTED_2XX | Schema de resposta deve estar aninhado sob um status 2XX | Use um status code válido |
| FST_ERR_INIT_OPTS_INVALID | Opções de inicialização inválidas | Use opções válidas |
| FST_ERR_FORCE_CLOSE_CONNECTIONS_IDLE_NOT_AVAILABLE | `forceCloseConnections: 'idle'` não suportado pelo HTTP server | Use outro valor |
| FST_ERR_DUPLICATED_ROUTE | Método HTTP já tem controller registrado para essa URL | Use URL diferente ou outro método |
| FST_ERR_BAD_URL | Router recebeu URL inválida | Use uma URL válida |
| FST_ERR_MAX_PARAM_LENGTH | URL excede tamanho máximo de parâmetro | Ajuste o tamanho do param ou o máximo permitido |
| FST_ERR_ASYNC_CONSTRAINT | Erro em constraint assíncrona do router | — |
| FST_ERR_INVALID_URL | URL deve ser string | Use string |
| FST_ERR_ROUTE_OPTIONS_NOT_OBJ | Opções da rota devem ser objeto | Use objeto |
| FST_ERR_ROUTE_DUPLICATED_HANDLER | Handler duplicado para a rota | Use handler diferente |
| FST_ERR_ROUTE_HANDLER_NOT_FN | Handler da rota deve ser função | Use função |
| FST_ERR_ROUTE_MISSING_HANDLER | Falta função handler na rota | Adicione um handler |
| FST_ERR_ROUTE_METHOD_INVALID | Método não é um valor válido | Use um valor válido |
| FST_ERR_ROUTE_METHOD_NOT_SUPPORTED | Método não suportado para a rota | Use um método suportado |
| FST_ERR_ROUTE_LOG_LEVEL_INVALID | `logLevel` não bate com nível configurado no logger | Use um nível válido |
| FST_ERR_ROUTE_BODY_VALIDATION_SCHEMA_NOT_SUPPORTED | Schema de validação de body não suportado na rota | Use outro método |
| FST_ERR_ROUTE_BODY_LIMIT_OPTION_NOT_INT | `bodyLimit` deve ser inteiro | Use um inteiro |
| FST_ERR_HANDLER_TIMEOUT | Requisição deu timeout | Aumente `handlerTimeout` ou otimize o handler |
| FST_ERR_ROUTE_HANDLER_TIMEOUT_OPTION_NOT_INT | `handlerTimeout` deve ser inteiro positivo | Use inteiro positivo |
| FST_ERR_ROUTE_REWRITE_NOT_STR | `rewriteUrl` deve ser string | Use string |
| FST_ERR_ROUTE_MISSING_CONTENT_TYPE | Header `Content-Type` obrigatório e ausente | Envie o header |
| FST_ERR_ROUTE_MISSING_CONTENT | Body obrigatório e ausente | Envie o payload |
| FST_ERR_REOPENED_CLOSE_SERVER | Fastify já foi fechado, não pode reabrir | — |
| FST_ERR_REOPENED_SERVER | Fastify já está escutando | — |
| FST_ERR_PLUGIN_VERSION_MISMATCH | Plugin instalado não bate com a versão esperada do Fastify | Use versão compatível do plugin |
| FST_ERR_PLUGIN_CALLBACK_NOT_FN | Callback de um hook não é função | Use função |
| FST_ERR_PLUGIN_NOT_VALID | Plugin deve ser função ou Promise | Use função ou Promise |
| FST_ERR_ROOT_PLG_BOOTED | Plugin raiz já iniciou | — |
| FST_ERR_PARENT_PLUGIN_BOOTED | Impossível carregar plugin porque o pai já iniciou (via `avvio`) | — |
| FST_ERR_PLUGIN_TIMEOUT | Plugin não iniciou a tempo | Aumente o timeout do plugin, ou verifique se `done()`/a Promise nunca resolve |
| FST_ERR_PLUGIN_NOT_PRESENT_IN_INSTANCE | Decorator não presente na instância | — |
| FST_ERR_PLUGIN_INVALID_ASYNC_HANDLER | Plugin mistura estilo async e callback | Escolha um estilo só |
| FST_ERR_PLUGIN_DEPENDENCY_NOT_REGISTERED | Dependência de um plugin não foi registrada | Registre a dependência antes |
| FST_ERR_VALIDATION | Requisição falhou na validação do payload | Verifique o payload da requisição |
| FST_ERR_LISTEN_OPTIONS_INVALID | Opções de `listen` inválidas | Verifique as opções de listen |
| FST_ERR_ERROR_HANDLER_NOT_FN | Error handler deve ser função | Forneça função a `setErrorHandler` |
| FST_ERR_ERROR_HANDLER_ALREADY_SET | `setErrorHandler` já foi definido nesse contexto | — |

Fonte: https://fastify.dev/docs/latest/Reference/Errors/ (verificar a versão
mais recente se o código não bater — a lista evolui a cada release).
