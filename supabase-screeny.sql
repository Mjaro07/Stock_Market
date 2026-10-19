-- Screeny wykresów przy transakcjach. Uruchom raz w Supabase: SQL Editor -> New query -> Run.
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
