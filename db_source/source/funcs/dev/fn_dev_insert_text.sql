drop function test.fn_dev_insert_text;
create or replace function test.fn_dev_insert_text(text_data jsonb, source_id integer, query_id integer) returns json
    language plpgsql
as
$$
DECLARE
        return_row record;
    BEGIN
        RAISE WARNING '%', text_data::jsonb -> 'authors';
        EXECUTE
            'INSERT INTO test.texts (name, authors, link, source_id, year, description, query_id, resource) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *'
        INTO return_row
        USING text_data::jsonb ->> 'name',
              text_data::jsonb -> 'authors',
              text_data::jsonb ->> 'link',
              source_id,
              to_date(text_data::jsonb ->> 'year', 'YYYY'),
              text_data::jsonb ->> 'info',
              ARRAY [query_id],
              text_data::jsonb ->> 'resource';
        RETURN row_to_json(return_row);
    end
$$;
alter function test.fn_dev_insert_text(jsonb, integer, integer) owner to bkmanager;
------------------------------------------------------------------------------
------------------------------------------------------------------------------


