#include "variantstreewidget.h"


#include <QtQuick>

VariantsTreeWidget::VariantsTreeWidget(QQuickItem* parent) :  QQuickPaintedItem(parent)
{
    mTree = new QTreeView();
    setAcceptedMouseButtons(Qt::AllButtons);

}

void VariantsTreeWidget::setModel(ResultsTreeModel* model)
{
    mModel = model;
    mTree->setModel(model);
    connect(model, SIGNAL(isLoadingChanged()), this, SLOT(update()));

    update();
    emit modelChanged();
}

void VariantsTreeWidget::paint(QPainter* painter)
{


    int rc = mModel->rowCount();
    int cc = mModel->columnCount();

    mTree->resize(width(), height());
    mTree->render(painter);

//    QBrush brush(QColor("#007430"));

//    painter->setBrush(brush);
//    painter->setPen(Qt::NoPen);
//    painter->setRenderHint(QPainter::Antialiasing);

//    QSizeF itemSize = size();
//    painter->drawRoundedRect(0, 0, itemSize.width(), itemSize.height() - 10, 10, 10);

//    if (true)
//    {
//        const QPointF points[3] = {
//            QPointF(itemSize.width() - 10.0, itemSize.height() - 10.0),
//            QPointF(itemSize.width() - 20.0, itemSize.height()),
//            QPointF(itemSize.width() - 30.0, itemSize.height() - 10.0),
//        };
//        painter->drawConvexPolygon(points, 3);
//    }
//    else
//    {
//        const QPointF points[3] =
//        {
//            QPointF(10.0, itemSize.height() - 10.0),
//            QPointF(20.0, itemSize.height()),
//            QPointF(30.0, itemSize.height() - 10.0),
//        };
//        painter->drawConvexPolygon(points, 3);
//    }
}



void VariantsTreeWidget::mousePressEvent(QMouseEvent *event)
{
    // Todo using TreeViewProxy
    //mTree->mousePressEvent(event);
    QPointF pos = event->localPos();
    qDebug() << "mousePressEvent" << pos.x() << pos.y();
}

void VariantsTreeWidget::mouseReleaseEvent(QMouseEvent *event)
{
    // Todo using TreeViewProxy
    //mTree->mouseReleaseEvent(event);
    QPointF pos = event->localPos();
    qDebug() << "mouseReleaseEvent" << pos.x() << pos.y();
}

void VariantsTreeWidget::mouseMoveEvent(QMouseEvent *event)
{
    // Todo using TreeViewProxy
    //mTree->mouseMoveEvent(event);
    QPointF pos = event->localPos();
    qDebug() << "mouseMoveEvent" << pos.x() << pos.y();
}

void VariantsTreeWidget::wheelEvent(QWheelEvent *event)
{
    // Todo using TreeViewProxy
    //mTree->wheelEvent(event);
    qDebug() << "wheelEvent" << event->angleDelta();
}
