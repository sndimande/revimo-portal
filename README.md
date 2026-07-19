# Portal e Plataforma de Gestão Rodoviária da REVIMO

Protótipo online-ready organizado em três áreas:

1. `index.html` — Portal Público com informação institucional, rede viária, portagens, tarifas, segurança e contactos;
2. `portal.html` — Área do Utente para cadastro, cartão, e-tag, benefícios, viaturas, documentos, reclamações e acompanhamento;
3. `gestao.html` — Base de Gestão Rodoviária para administração de utentes, pedidos, rede, activos, portagens, incidentes e relatórios.

## Abrir localmente

Abra `index.html` num navegador moderno. As interacções demonstrativas utilizam `localStorage`, permitindo que um pedido criado na Área do Utente apareça no painel de gestão no mesmo navegador.

## Colocar online

O front-end pode ser publicado no GitHub Pages, Netlify ou servidor institucional. Para operação real:

1. Criar um projecto no Supabase;
2. Executar `supabase-schema.sql`;
3. Copiar `config.example.js` para `config.js` e preencher URL e chave publicável;
4. Integrar autenticação, armazenamento documental e chamadas à base de dados;
5. Rever políticas de acesso, protecção de dados, auditoria, backups e segurança;
6. Validar tarifas, categorias de benefício e regras com a REVIMO antes da entrada em produção.

## Conteúdo institucional

O conteúdo público foi estruturado a partir do website oficial da REVIMO consultado em 19/07/2026. Tarifas e informação operacional devem ser reconfirmadas antes da publicação definitiva.

## Importante

Os nomes, movimentos, métricas e pedidos apresentados na demonstração são fictícios. O protótipo não deve ser usado para recolher dados pessoais reais enquanto não estiver ligado a uma base segura e sujeito a validação institucional.
