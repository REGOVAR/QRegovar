#ifndef VARIANTSTREEWIDGET_H
#define VARIANTSTREEWIDGET_H

#include <QQuickPaintedItem>
#include <QTreeView>

#include "Model/analysis/filtering/resultstreemodel.h"

class VariantsTreeWidget : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(ResultsTreeModel* model READ model WRITE setModel NOTIFY modelChanged)

public:
    // Constructors
    explicit VariantsTreeWidget(QQuickItem* parent=nullptr);

    // Getters
    inline ResultsTreeModel* model() const { return mModel; }

    // Setters
    Q_INVOKABLE void setModel(ResultsTreeModel* model);

    // QQuickPaintedItem methods
    void paint(QPainter* painter);

    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void wheelEvent(QWheelEvent *event) override;

Q_SIGNALS:
    void modelChanged();

private:
    QTreeView* mTree;
    ResultsTreeModel* mModel;
};

#endif // VARIANTSTREEWIDGET_H
