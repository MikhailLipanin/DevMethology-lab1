-- Создание функции для триггера
CREATE OR REPLACE FUNCTION check_souvenirs_category()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.idparent IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM souvenirscategories WHERE id = NEW.idparent) THEN
            RAISE EXCEPTION 'Parent category with ID % does not exist', NEW.idparent;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера на вставку или обновление данных
CREATE TRIGGER validate_souvenirs_category
    BEFORE INSERT OR UPDATE
    ON souvenirscategories
    FOR EACH ROW
EXECUTE FUNCTION check_souvenirs_category();
