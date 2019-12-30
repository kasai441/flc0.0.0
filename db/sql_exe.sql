--select * from quizcards where name IS NULL
--select name, count(name) from quizcards group by name order by count(name) desc
--２つ以上重複するレコード
select  (w.wait_sequence - 6), q.* from quizcards q, waitdays w where q.id = w.quizcard_id and q.name in ( select name from quizcards group by name having count(name) >= 2) order by q.name