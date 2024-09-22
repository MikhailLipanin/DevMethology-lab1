-- Создание функции для триггера
CREATE OR REPLACE FUNCTION notify_low_stock()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.amount < 50 THEN
        RAISE NOTICE 'Low stock alert: Souvenir ID % has only % items left in stock', NEW.idsouvenir, NEW.amount;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера на вставку или обновление данных
CREATE TRIGGER check_low_stock
    AFTER INSERT OR UPDATE
    ON souvenirstores
    FOR EACH ROW
EXECUTE FUNCTION notify_low_stock();
