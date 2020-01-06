--select * from quizcards where name IS NULL
--select name, count(name) from quizcards group by name order by count(name) desc
--２つ以上重複するレコード
--select  (w.wait_sequence - 6), q.* from quizcards q, waitdays w where q.id = w.quizcard_id and q.name in ( select name from quizcards group by name having count(name) >= 2) order by q.name
--select substr(name, 1, 6) as ln, count(*) from quizcards group by ln having count(ln) > 1 order by count(*) desc
--select  (w.wait_sequence - 6), q.*, substr(q.name, 1, 5) as ln from quizcards q, waitdays w where q.id = w.quizcard_id and ln IN ( select substr(name, 1, 5) as ln from quizcards group by ln having count(ln) > 1 ) order by ln
--select * from quizcards where substr(name, -1, 1) like "2" or substr(name, -1, 1) like "3" or substr(name, -1, 1) like "1" or substr(name, -1, 1) like ")" or substr(name, 1, 1) like "+"
--select  (w.wait_sequence - 6), q.* from quizcards q, waitdays w where q.id = w.quizcard_id and name IN ( select  name from quizcards where substr(name, -1, 1) like "2" or substr(name, -1, 1) like "3" or substr(name, -1, 1) like "1" or substr(name, -1, 1) like ")" or substr(name, -1, 1) like " " or substr(name, 1, 1) like "+"  or substr(name, 1, 1) like " " ) order by w.wait_sequence
select  (w.wait_sequence - 6), q.* from quizcards q, waitdays w where q.id = w.quizcard_id and name IN ( select  name from quizcards where name like "%2%" or name like "%3%" or name like "%1%" or name like "%4%" or name like "%)%" or substr(name, -1, 1) like " " or name like "%+%"  or substr(name, 1, 1) like " "  or name like "%,%" or name like "%/%" or name like "%sb%" or name like "%sth%"  ) order by w.wait_sequence
