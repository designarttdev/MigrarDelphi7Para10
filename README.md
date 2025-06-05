<h1 align="center">Migrar projetos para Delphi 10+</h1>

<p align="center">
  Este projeto veio para facilitar a conversão de projetos feitos em delphi em versões menores que o 10.
  <br />
  Facilitando a vida dos devs que antes precisavam fazer esta conversão na mão.
  <br />
  <br />
  <a href="https://github.com/designarttdev/MigrarDelphi7Para10/issues">Reportar Bug</a>
  ·
  <a href="https://github.com/designarttdev/MigrarDelphi7Para10/issues">Solicitar Funcionalidade</a>
</p>

---

## 📖 Índice

- [Sobre o Projeto](#sobre-o-projeto)
  - [Construído Com](#construído-com)
- [Começando](#começando)
  - [Instalação](#instalação)
- [🚀 Uso](#uso)
  - [Como Contribuir](#como-contribuir)
- [📝 Licença](#licença)
- [📫 Contato](#contato)

---

## Sobre o Projeto

<!-- ![Screenshot do Projeto](URL_para_screenshot_do_projeto) -->

Um projeto nascido da necessidade de fazer conversões mais rápidas de projetos antigos de Delphi, para a versão mais nova do Delphi 10+.

Veio com o intúito de facilitar a vida dos devs, onde antes tinham que fazer tudo na mão, hoje não precisa mais, pelo menos 90% das vezes sem a necessidade de fazer reajustes no código.

### Construído Com

- [Delphi Rio](https://www.embarcadero.com/br/products/delphi)

---

## Começando

Para obter uma cópia basta seguir o seguinte processo.

## Instalação

Clone o repositório

```sh
git clone https://github.com/designarttdev/MigrarDelphi7Para10.git
```

---

## Uso

### Funcionalidades
- Salvar as palavras que você quer alterar;
  - Exemplo: TADConnection -> TFDConnection
- Facilidade em alterar as palavras em todo o projeto.

### Como converter um projeto Delphi 7
1. Execute o aplicativo `MigrarDelphi7Para10`.
2. Clique em **Pasta...** e escolha o diretório do projeto em Delphi 7.
3. Se nenhum arquivo `.dpr` for encontrado, o programa perguntará se deseja prosseguir mesmo assim.
4. Ao pressionar **Converter**, os arquivos `.pas` e `.dfm` convertidos são salvos na subpasta `Convertido`.
5. As conversões são baseadas na tabela `CONVERSAO` do banco `Bin/Banco/Banco.db`.
6. Abra o projeto na pasta `Convertido` com o Delphi 10+ e finalize os ajustes necessários.

---
### Como Contribuir
Faça um Fork do projeto
Crie uma Branch para sua Feature (git checkout -b feature/AmazingFeature)
Faça o Commit de suas mudanças (git commit -m 'Add some AmazingFeature')
Faça o Push para a Branch (git push origin feature/AmazingFeature)
Abra um Pull Request

### Licença
Distribuído sob a Licença MIT. Veja LICENSE para mais informações.

### Contato
Luiz Carlos - [Instagram](https://instagram.com/designarttoficial)

Link do Projeto: [Repositório Git](https://github.com/designarttdev/MigrarDelphi7Para10)
