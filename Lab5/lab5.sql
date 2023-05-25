-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Май 25 2023 г., 15:17
-- Версия сервера: 10.4.28-MariaDB
-- Версия PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `lab5`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `BookDate_T1` ()   BEGIN
    SELECT book.Name, book.Price, producer.Producer_Name, format.Format_Name
    FROM book
    JOIN producer ON book.ProducerID = producer.ID_Producer
    JOIN format ON book.FormatID = format.ID_Format;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookDate_T10` ()   BEGIN
  SELECT * FROM producer
  WHERE ( SELECT MAX(Pages) 
         FROM book 
         WHERE book.ProducerID = producer.ID_Producer) >= 400;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookDate_T11` ()   BEGIN
  SELECT * FROM category 
  WHERE(SELECT COUNT(*) 
        FROM book 
        WHERE book.CategoryID = category.ID_Category) > 3;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookDate_T12` ()   BEGIN
  SELECT * FROM book 
  WHERE EXISTS (SELECT * 
                FROM producer 
                WHERE producer.Producer_Name = 'BHV' 
                AND book.ProducerID = producer.ID_Producer);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookDate_T13` ()   BEGIN
  SELECT * FROM book 
  WHERE NOT EXISTS (SELECT * 
                    FROM producer 
                    WHERE producer.Producer_Name = 'BHV' AND book.ProducerID = producer.ID_Producer);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookDate_T14` ()   BEGIN
  SELECT * FROM category 
  UNION SELECT * FROM topic 
  ORDER BY Category_Name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookDate_T15` ()   BEGIN
  SELECT Word FROM ( SELECT LEFT(Name, LOCATE(' ', Name) - 1) AS Word 
                    FROM book UNION SELECT category.Category_Name 
                    FROM category ) AS combined 
                    GROUP BY Word ORDER BY Word DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookDate_T2` (IN `topic_name` VARCHAR(255), IN `category_name` VARCHAR(255))   BEGIN
    SELECT topic.Topic_Name, category.Category_Name, book.Name, producer.Producer_Name
    FROM book
    JOIN topic ON book.TopicID = topic.ID_Topic
    JOIN category ON book.CategoryID = category.ID_Category
    JOIN producer ON book.ProducerID = producer.ID_Producer
    WHERE topic.Topic_Name = topic_name AND category.Category_Name = category_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookDate_T5` ()   BEGIN
  SELECT AVG(book.Price), category.Category_Name, topic.Topic_Name
    FROM book
    JOIN category ON book.CategoryID = category.ID_Category
    JOIN topic ON book.TopicID = topic.ID_Topic
    WHERE topic.ID_Topic = 1 AND category.ID_Category = 6;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookDate_T6` ()   BEGIN
  SELECT book.Number, book.CodeID, book.New, book.Name, book.Price, book.Pages, book.Date, 
  format.Format_Name, producer.Producer_Name, category.Category_Name, topic.Topic_Name 
  FROM book, format, producer, category, topic 
  WHERE book.FormatID = format.ID_Format AND book.ProducerID = producer.ID_Producer 
  AND book.CategoryID = category.ID_Category AND book.TopicID = topic.ID_Topic;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookDate_T7` ()   BEGIN
  SELECT book1.Name AS book1_Name, book2.Name AS book2_Name, book1.Pages AS Pages 
  FROM book book1 JOIN book book2 ON book1.Pages = book2.Pages 
  AND book1.Number <> book2.Number;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookDate_T8` ()   BEGIN
  SELECT book1.Name AS book1_Name, book2.Name AS book2_Name, book3.Name AS book3_Name, book1.Price AS Price 
  FROM book book1 JOIN book book2 ON book1.Price = book2.Price 
  JOIN book book3 ON book1.Price = book3.Price 
  WHERE book1.Number < book2.Number AND book2.Number < book3.Number;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookDate_T9` ()   BEGIN
  SELECT * FROM book, category 
  WHERE category.Category_Name = 'C&C++' AND book.CategoryID = category.ID_Category;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookProdYear_T3` ()   BEGIN
  SELECT * FROM book, producer
  WHERE producer.Producer_Name = 'BHV' AND YEAR(Date) > 2000;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookProdYear_T4ASC` ()   BEGIN
  SELECT category.Category_Name, SUM(Pages) AS SUM_Pages 
  FROM book 
  JOIN category ON book.CategoryID = category.ID_Category 
  GROUP BY category.Category_Name 
  ORDER BY SUM_Pages ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookProdYear_T4DESC` ()   BEGIN
  SELECT category.Category_Name, SUM(Pages) AS SUM_Pages 
  FROM book 
  JOIN category ON book.CategoryID = category.ID_Category 
  GROUP BY category.Category_Name 
  ORDER BY SUM_Pages DESC;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `book`
--

CREATE TABLE `book` (
  `Number` int(11) NOT NULL,
  `CodeID` int(11) NOT NULL,
  `New` varchar(5) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Price` float DEFAULT NULL,
  `ProducerID` int(11) NOT NULL,
  `Pages` int(11) NOT NULL CHECK (`Pages` > 0),
  `FormatID` int(11) NOT NULL,
  `Date` date DEFAULT NULL,
  `Circulation` int(11) NOT NULL CHECK (`Circulation` > 0),
  `TopicID` int(11) NOT NULL,
  `CategoryID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `book`
--

INSERT INTO `book` (`Number`, `CodeID`, `New`, `Name`, `Price`, `ProducerID`, `Pages`, `FormatID`, `Date`, `Circulation`, `TopicID`, `CategoryID`) VALUES
(1, 5110, 'No', 'Апаратні засоби мультимедіа.Відеосистема PC', 15.51, 1, 400, 1, '2000-07-24', 5000, 1, 1),
(2, 4985, 'No', 'Засвой самостійно модернізацію та ремонт ПК за 24 години, 2-ге вид', 18.9, 2, 288, 1, '2000-07-07', 5000, 1, 1),
(3, 5141, 'No', 'Структури даних та алгоритми.', 37.8, 2, 384, 1, '2000-09-29', 5000, 1, 1),
(4, 5127, 'No', 'Автоматизація інженерно-графічних робіт', 11.58, 1, 256, 1, '2000-06-15', 5000, 1, 1),
(5, 5110, 'No', 'Апаратні засоби мультимедіа. Відеосистема РС', 15.51, 1, 400, 1, '2000-07-24', 5000, 1, 2),
(6, 5199, 'No', 'Залізо IBM 2001. ', 30.07, 3, 368, 1, '2000-12-02', 5000, 1, 2),
(7, 3851, 'No', 'Захист інформації та безпека компьютерних систем', 26, 4, 480, 2, '1999-02-04', 5000, 1, 3),
(8, 3932, 'No', ' Як перетворити персональний компьютер на вимірювальний комплекс', 7.65, 5, 144, 3, '1999-06-09', 5000, 1, 4),
(9, 4713, 'No', 'Plug- ins. Додаткові програми для музичних програм', 11.41, 5, 144, 1, '2000-02-22', 5000, 1, 4),
(10, 5217, 'No', 'Windows МЕ. Найновіші версії програм', 16.57, 6, 320, 1, '2000-08-25', 5000, 2, 5),
(11, 4829, 'No', 'Windows 2000 Professional крок за кроком СD', 27.25, 7, 320, 1, '2000-04-28', 5000, 2, 5),
(12, 5170, 'No', 'Linux  версії', 24.43, 5, 346, 1, '2000-09-29', 5000, 2, 6),
(13, 860, 'No', 'Операційна система UNIX', 3.5, 1, 395, 4, '1997-05-05', 5000, 2, 7),
(14, 44, 'No', 'Відповіді на актуальні запитання щодо OS/2 Warp', 5, 4, 352, 5, '1996-03-20', 5000, 2, 8),
(15, 5176, 'No', 'Windows Ме. Спутник користувач', 12.79, 1, 306, 1, '2000-10-10', 5000, 2, 8),
(16, 5462, 'No', 'Мова програмування С++. Лекції та вправи ', 29, 4, 656, 2, '2000-12-12', 5000, 3, 9),
(17, 4982, 'No', 'Мова програмування С. Лекції та вправи', 29, 4, 432, 2, '2000-07-12', 5000, 3, 9),
(18, 4687, 'No', 'Ефективне використання C++ .50 рекомендацій щодо покращення ваших програм та проектів', 17.6, 5, 240, 1, '2000-02-03', 5000, 3, 9),
(19, 235, 'No', 'Інформаційні системи і структури даних', NULL, 8, 288, 6, '0000-00-00', 400, 1, 4),
(20, 8746, 'Yes', 'Бази даних в інформаційних системах', NULL, 9, 418, 5, '2018-07-25', 100, 3, 10),
(21, 2154, 'Yes', 'Сервер на основі операційної системи FreeBSD 6.1', 0, 9, 216, 5, '2015-11-03', 500, 3, 8),
(22, 2662, 'No', 'Організація баз даних та знань', 0, 10, 208, 6, '2001-10-10', 1000, 3, 10),
(23, 5641, 'Yes', 'Організація баз даних та знань', 0, 1, 384, 1, '2021-12-15', 5000, 3, 10);

-- --------------------------------------------------------

--
-- Структура таблицы `category`
--

CREATE TABLE `category` (
  `ID_Category` int(11) NOT NULL,
  `Category_Name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `category`
--

INSERT INTO `category` (`ID_Category`, `Category_Name`) VALUES
(1, 'Підручники'),
(2, 'Апаратні засоби'),
(3, 'Захист і безпека ПК'),
(4, 'Інші книги'),
(5, 'Windows 2000'),
(6, 'Linux'),
(7, 'Unix'),
(8, 'Інші операційні системи'),
(9, 'C&C++'),
(10, 'SQL');

-- --------------------------------------------------------

--
-- Структура таблицы `format`
--

CREATE TABLE `format` (
  `ID_Format` int(11) NOT NULL,
  `Format_Name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `format`
--

INSERT INTO `format` (`ID_Format`, `Format_Name`) VALUES
(1, '70х100/16'),
(2, '84х108/16'),
(3, '60х88/16'),
(4, '84х100/16'),
(5, '60х84/16'),
(6, '60х90/16');

-- --------------------------------------------------------

--
-- Структура таблицы `producer`
--

CREATE TABLE `producer` (
  `ID_Producer` int(11) NOT NULL,
  `Producer_Name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `producer`
--

INSERT INTO `producer` (`ID_Producer`, `Producer_Name`) VALUES
(1, 'BHV'),
(2, 'Вільямс'),
(3, 'МікроАрт'),
(4, 'DiaSoft'),
(5, 'ДМК'),
(6, 'Триумф'),
(7, 'Еком'),
(8, 'Києво-Могилянська академія'),
(9, 'Університет \"Україна\"'),
(10, 'Вінниця: ВДТУ');

-- --------------------------------------------------------

--
-- Структура таблицы `topic`
--

CREATE TABLE `topic` (
  `ID_Topic` int(11) NOT NULL,
  `Topic_Name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `topic`
--

INSERT INTO `topic` (`ID_Topic`, `Topic_Name`) VALUES
(1, 'Використання ПК в цілому'),
(2, 'Операційні системи'),
(3, 'Програмування');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `book`
--
ALTER TABLE `book`
  ADD PRIMARY KEY (`Number`),
  ADD KEY `ProducerID` (`ProducerID`),
  ADD KEY `TopicID` (`TopicID`),
  ADD KEY `CategoryID` (`CategoryID`),
  ADD KEY `FormatID` (`FormatID`);

--
-- Индексы таблицы `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`ID_Category`);

--
-- Индексы таблицы `format`
--
ALTER TABLE `format`
  ADD PRIMARY KEY (`ID_Format`);

--
-- Индексы таблицы `producer`
--
ALTER TABLE `producer`
  ADD PRIMARY KEY (`ID_Producer`);

--
-- Индексы таблицы `topic`
--
ALTER TABLE `topic`
  ADD PRIMARY KEY (`ID_Topic`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `book`
--
ALTER TABLE `book`
  MODIFY `Number` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT для таблицы `category`
--
ALTER TABLE `category`
  MODIFY `ID_Category` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `format`
--
ALTER TABLE `format`
  MODIFY `ID_Format` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `producer`
--
ALTER TABLE `producer`
  MODIFY `ID_Producer` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `topic`
--
ALTER TABLE `topic`
  MODIFY `ID_Topic` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `book`
--
ALTER TABLE `book`
  ADD CONSTRAINT `book_ibfk_1` FOREIGN KEY (`ProducerID`) REFERENCES `producer` (`ID_Producer`) ON DELETE CASCADE,
  ADD CONSTRAINT `book_ibfk_2` FOREIGN KEY (`TopicID`) REFERENCES `topic` (`ID_Topic`) ON DELETE CASCADE,
  ADD CONSTRAINT `book_ibfk_3` FOREIGN KEY (`CategoryID`) REFERENCES `category` (`ID_Category`) ON DELETE CASCADE,
  ADD CONSTRAINT `book_ibfk_4` FOREIGN KEY (`FormatID`) REFERENCES `format` (`ID_Format`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
