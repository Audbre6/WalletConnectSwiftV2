import Foundation

public struct SqliteQuery {

    public static func replace(table: String, rows: [SqliteRow]) throws -> String {
        var values: [String] = []

        for row in rows {
            values.append(row.encode().values
                .map { "'\($0.value)'" }
                .joined(separator: ", "))
        }

        guard let first = rows.first else {
            throw Errors.rowsNotFound
        }

        let formattedArguments = first.encode().values
            .map { $0.argument }
            .joined(separator: ", ")

        let formattedValues = values
            .map { "(\($0))" }
            .joined(separator: ",\n")

        return """
            REPLACE INTO \(table) (\(formattedArguments)) VALUES
            \(formattedValues);
        """
    }

    public static func select(table: String) -> String {
        return "SELECT * FROM \(table);"
    }

    public static func select(table: String, where argument: String, equals value: String) -> String {
        return "SELECT * FROM \(table) WHERE \(argument) = '\(value)';"
    }

    public static func delete(table: String, where argument: String, equals value: String) -> String {
        return "DELETE FROM \(table) WHERE \(argument) = '\(value)';"
    }
}

extension SqliteQuery {

    enum Errors: Error {
        case rowsNotFound
    }
}
