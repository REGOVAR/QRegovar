#include <QDebug>
#include "projectsbrowsermodel.h"
#include "projectsbrowseritem.h"

ProjectsBrowserModel::ProjectsBrowserModel() : TreeModel(0)
{
    QList<QVariant> rootData;
    rootData << "Name" << "Date" << "Comment";
    rootItem = new TreeItem(rootData);

    // TODO : retrieve data from Rest request
    QFile file("E:/Git/QRegovar/test.txt");
    file.open(QIODevice::ReadOnly);
    QString data =  file.readAll();
    file.close();

    setupModelData(data.split(QString("\n")), rootItem);
}


QHash<int, QByteArray> ProjectsBrowserModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[DateRole] = "date";
    roles[CommentRole] = "comment";
    return roles;
}



QVariant ProjectsBrowserModel::newProjectsBrowserItem(const QString &text, int position)
{
    ProjectsBrowserItem *t = new ProjectsBrowserItem(this);
    t->setText(text);
    t->setIndentation(position);
    QVariant v;
    v.setValue(t);
    return v;
}

//void ProjectsBrowserModel::setupModelData(const QStringList &lines, TreeItem *parent)
//{
//    QList<TreeItem*> parents;
//    QList<int> indentations;
//    parents << parent;
//    indentations << 0;

//    int number = 0;

//    while (number < lines.count()) {
//        int position = 0;
//        while (position < lines[number].length()) {
//            if (lines[number].at(position) != ' ')
//                break;
//            ++position;
//        }

//        QString lineData = lines[number].mid(position).trimmed();

//        if (!lineData.isEmpty()) {
//            // Read the column data from the rest of the line.
//            QStringList columnStrings = lineData.split("\t", QString::SkipEmptyParts);
//            QVector<QVariant> columnData;
//            for (int column = 0; column < columnStrings.count(); ++column)
//                columnData << columnStrings[column]; //newProjectsBrowserItem(columnStrings[column], position);

//            if (position > indentations.last()) {
//                // The last child of the current parent is now the new parent
//                // unless the current parent has no children.

//                if (parents.last()->childCount() > 0) {
//                    parents << parents.last()->child(parents.last()->childCount()-1);
//                    indentations << position;
//                }
//            } else {
//                while (position < indentations.last() && parents.count() > 0) {
//                    parents.pop_back();
//                    indentations.pop_back();
//                }
//            }

//            // Append a new item to the current parent's list of children.
//            TreeItem *parent = parents.last();
//            parent->insertChildren(parent->childCount(), 1, rootItem->columnCount());
//            for (int column = 0; column < columnData.size(); ++column)
//                parent->child(parent->childCount() - 1)->setData(column, columnData[column]);
//        }
//        qDebug() << "Model2 [" << number << "] : " << position;
//        ++number;
//    }
//}
