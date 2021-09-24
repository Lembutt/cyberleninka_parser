drop function test.fn_dev_get_source_id;
create function test.fn_dev_get_source_id(source_name text, source_link text, resource text) returns integer
    language plpgsql
as
$$
DECLARE
        id_ integer;
        links_ jsonb;
    BEGIN
        EXECUTE
            'SELECT id, links FROM test.sources WHERE name=$1;'
        INTO id_, links_
        USING source_name, source_link;
        IF id_ isnull THEN
            EXECUTE
                'INSERT INTO test.sources(name, links) VALUES ($1, $2) RETURNING id;'
            INTO id_
            USING source_name, jsonb_build_object(resource, source_link);
        ELSE
            IF links_ @> jsonb_build_object(resource, source_link)::jsonb is false THEN
                UPDATE test.sources
                SET links = links_ || jsonb_build_object(resource, source_link)
                WHERE id=id_;
            end if;
        end if;
        return id_;
    END
$$;
alter function test.fn_dev_get_source_id(text, text, text) owner to bkmanager;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
drop function test.fn_dev_get_text;
create function test.fn_dev_get_text(text_name text) returns json
    language plpgsql
as
$$
DECLARE
        return_row record;
    BEGIN
        EXECUTE
            'select * from test.texts where name=$1;'
        INTO return_row
        USING text_name;
        RETURN row_to_json(return_row);
    end
$$;
alter function test.fn_dev_get_text(text) owner to bkmanager;
------------------------------------------------------------------------------
------------------------------------------------------------------------------
drop function test.fn_dev_insert_text;
create function test.fn_dev_insert_text(text_data json, source_id integer) returns json
    language plpgsql
as
$$
DECLARE
        return_row record;
    BEGIN
        EXECUTE
            'INSERT INTO test.texts (name, authors, link, source_id, year, description, query, resource) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *'
        INTO return_row
        USING text_data::json ->> 'name',
              text_data::json -> 'authors',
              text_data::json ->> 'link',
              source_id,
              to_date(text_data::json ->> 'year', 'YYYY'),
              text_data::json ->> 'description',
              text_data::json -> 'query',
              text_data::json ->> 'resource';
        RETURN row_to_json(return_row);
    end
$$;
alter function test.fn_dev_insert_text(json, integer) owner to bkmanager;

