-- Dziennik Tradera: tabela transakcji. Wklej całość w Supabase > SQL Editor > New query > Run.
create table if not exists public.trades (
  user_id      uuid not null default auth.uid() references auth.users on delete cascade,
  id           text not null,
  instrument   text not null,
  side         text not null default 'BUY',
  volume       numeric,
  open_time    timestamp,
  entry_price  numeric,
  exit_price   numeric,
  sl           numeric,
  tp           numeric,
  pnl          numeric not null default 0,
  closed_by    text,
  setup        text default '',
  emotion      text default '',
  notes        text default '',
  rule_broken  boolean not null default false,
  source       text default 'manual',
  created_at   timestamptz not null default now(),
  primary key (user_id, id)
);

-- Każdy widzi i zmienia tylko swoje transakcje.
alter table public.trades enable row level security;

drop policy if exists "own trades select" on public.trades;
drop policy if exists "own trades insert" on public.trades;
drop policy if exists "own trades update" on public.trades;
drop policy if exists "own trades delete" on public.trades;
create policy "own trades select" on public.trades for select using (auth.uid() = user_id);
create policy "own trades insert" on public.trades for insert with check (auth.uid() = user_id);
create policy "own trades update" on public.trades for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own trades delete" on public.trades for delete using (auth.uid() = user_id);

-- Dostęp dla zalogowanych użytkowników (działa też, gdy „Automatically expose new tables” jest wyłączone).
grant select, insert, update, delete on public.trades to authenticated;

alter table public.trades add column if not exists chart_path text;

-- Prywatny schowek na obrazki (każdy użytkownik ma swój folder).
insert into storage.buckets (id, name, public) values ('charts', 'charts', false)
on conflict (id) do nothing;

drop policy if exists "own charts select" on storage.objects;
drop policy if exists "own charts insert" on storage.objects;
drop policy if exists "own charts update" on storage.objects;
drop policy if exists "own charts delete" on storage.objects;
create policy "own charts select" on storage.objects for select to authenticated
  using (bucket_id = 'charts' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "own charts insert" on storage.objects for insert to authenticated
  with check (bucket_id = 'charts' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "own charts update" on storage.objects for update to authenticated
  using (bucket_id = 'charts' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "own charts delete" on storage.objects for delete to authenticated
  using (bucket_id = 'charts' and (storage.foldername(name))[1] = auth.uid()::text);
