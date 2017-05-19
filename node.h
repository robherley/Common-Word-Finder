/*******************************************************************************
 * Name          : node.h
 * Author        : Brian S. Borowski
 * Version       : 1.1
 * Date          : October 8, 2014
 * Last modified : December 13, 2016
 * Description   : Implementation of node for binary search tree and
 *                 red-black tree.
 ******************************************************************************/
#ifndef NODE_H_
#define NODE_H_

#include <cstdlib>
#include <utility>

enum { RED, BLACK };

template<typename K, typename V>
class Node {
public:
    Node() : left_(NULL), right_(NULL), parent_(NULL) { }

    Node(const K &key, const V &value) :
        left_(NULL), right_(NULL), parent_(NULL),
        kv_pair_(std::make_pair(key, value)) { }

    virtual ~Node() { }

    virtual Node<K, V>* left() const {
        return left_;
    }

    virtual Node<K, V>* right() const {
        return right_;
    }

    virtual Node<K, V>* parent() const {
        return parent_;
    }

    inline void set_left(Node<K, V>* left) {
        left_ = left;
    }

    inline void set_right(Node<K, V>* right) {
        right_ = right;
    }

    inline void set_parent(Node<K, V>* parent) {
        parent_ = parent;
    }

    inline std::pair<K, V>& key_value() {
        return kv_pair_;
    }

    inline const K& key() const {
        return kv_pair_.first;
    }

    inline const V& value() const {
        return kv_pair_.second;
    }

    inline void set_value(const V &value) {
        kv_pair_.second = value;
    }

protected:
    Node<K, V> *left_, *right_, *parent_;

private:
    std::pair<K, V> kv_pair_;
};

template<typename K, typename V>
class RedBlackNode : public Node<K, V> {
public:
    typedef unsigned char color_t;

    RedBlackNode() : color_(RED) { }

    RedBlackNode(const K &key, const V &value) :
        Node<K, V>(key, value), color_(RED) { }

    ~RedBlackNode() { }

    RedBlackNode<K, V>* left() const {
        return static_cast< RedBlackNode<K, V>* >(Node<K, V>::left_);
    }

    RedBlackNode<K, V>* right() const {
        return static_cast< RedBlackNode<K, V>* >(Node<K, V>::right_);
    }

    RedBlackNode<K, V>* parent() const {
        return static_cast< RedBlackNode<K, V>* >(Node<K, V>::parent_);
    }

    inline color_t color() const {
        return color_;
    }

    inline void set_color(color_t color) {
        color_ = color;
    }

private:
    color_t color_;
};

#endif /* NODE_H_ */
