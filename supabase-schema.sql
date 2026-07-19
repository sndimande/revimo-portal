-- Estrutura inicial da Plataforma REVIMO. Executar no SQL Editor do Supabase.
create extension if not exists "uuid-ossp";
create type public.tipo_utente as enum ('normal','morador','regime_especial');
create type public.tipo_pedido as enum ('cartao','etag','beneficio_morador','regime_especial','substituicao','reclamacao');
create type public.estado_pedido as enum ('rascunho','recebido','em_analise','aguarda_correcao','aprovado','rejeitado','concluido');

create table public.perfis (id uuid primary key references auth.users on delete cascade, nome text not null, nuit text, telefone text, tipo tipo_utente default 'normal', criado_em timestamptz default now());
create table public.viaturas (id uuid primary key default uuid_generate_v4(), utente_id uuid not null references public.perfis on delete cascade, matricula text not null unique, classe smallint check (classe between 1 and 4), livrete text, activa boolean default true, criado_em timestamptz default now());
create table public.pracas (id uuid primary key default uuid_generate_v4(), nome text not null unique, corredor text not null, provincia text, activa boolean default true);
create table public.pedidos (id uuid primary key default uuid_generate_v4(), referencia text not null unique, utente_id uuid not null references public.perfis, viatura_id uuid references public.viaturas, praca_id uuid references public.pracas, tipo tipo_pedido not null, estado estado_pedido default 'recebido', justificacao text, decisao text, criado_em timestamptz default now(), actualizado_em timestamptz default now());
create table public.documentos (id uuid primary key default uuid_generate_v4(), pedido_id uuid not null references public.pedidos on delete cascade, nome text not null, caminho text not null, validade date, verificado boolean default false, criado_em timestamptz default now());
create table public.beneficios (id uuid primary key default uuid_generate_v4(), utente_id uuid not null references public.perfis, viatura_id uuid references public.viaturas, praca_id uuid references public.pracas, categoria tipo_utente not null, desconto numeric(5,2) check (desconto between 0 and 100), inicio date not null, fim date, activo boolean default true);
create table public.dispositivos (id uuid primary key default uuid_generate_v4(), utente_id uuid not null references public.perfis, viatura_id uuid references public.viaturas, tipo text check (tipo in ('cartao','etag')), numero text not null unique, saldo numeric(14,2) default 0, estado text default 'activo', emitido_em timestamptz default now());
create table public.passagens (id bigint generated always as identity primary key, dispositivo_id uuid references public.dispositivos, praca_id uuid references public.pracas, classe smallint, valor_bruto numeric(14,2), desconto numeric(14,2) default 0, valor_pago numeric(14,2), ocorrido_em timestamptz default now());
create table public.activos_rodoviarios (id uuid primary key default uuid_generate_v4(), codigo text unique, categoria text not null, nome text not null, corredor text, km numeric(10,2), latitude numeric, longitude numeric, estado text, ultima_inspeccao date, proxima_inspeccao date);
create table public.incidentes (id uuid primary key default uuid_generate_v4(), activo_id uuid references public.activos_rodoviarios, tipo text not null, prioridade text, descricao text, estado text default 'aberto', ocorrido_em timestamptz default now(), encerrado_em timestamptz);

alter table public.perfis enable row level security; alter table public.viaturas enable row level security; alter table public.pedidos enable row level security; alter table public.documentos enable row level security; alter table public.beneficios enable row level security; alter table public.dispositivos enable row level security; alter table public.passagens enable row level security;
create policy "utente lê o próprio perfil" on public.perfis for select using (auth.uid()=id);
create policy "utente actualiza o próprio perfil" on public.perfis for update using (auth.uid()=id);
create policy "utente gere as próprias viaturas" on public.viaturas for all using (auth.uid()=utente_id) with check (auth.uid()=utente_id);
create policy "utente cria e consulta pedidos" on public.pedidos for select using (auth.uid()=utente_id);
create policy "utente submete pedidos" on public.pedidos for insert with check (auth.uid()=utente_id);
create policy "utente consulta benefícios" on public.beneficios for select using (auth.uid()=utente_id);
create policy "utente consulta dispositivos" on public.dispositivos for select using (auth.uid()=utente_id);
