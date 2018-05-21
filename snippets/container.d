module snippets.container;

/++

See_also: https://github.com/beet-aizu/library/blob/master/avltree.cpp

 +/

import std.algorithm : max;
import std.functional : binaryFun;
import std.format : format;

struct AVLTree(T, alias cmp = "a < b") // , bool allowDuplicates = false)
    if (is(typeof(binaryFun!cmp(T.init, T.init) || T.init == T.init)))
{
    alias compare = binaryFun!cmp;
    struct Node {
        T key;
        size_t size = 1;
        size_t height = 1;
        Node*[2] child;

        ref left() { return child[0]; }
        ref right() { return child[1]; }

        bool isLeaf() { return left is null && right is null; }

        string _toString(string space="  ", size_t depth=1) {
            if (isLeaf) return format!"%s"(key);
            auto l = (left !is null) ? left._toString("  " ~ space, depth+1) : "(null)";
            auto r = (right !is null) ? right._toString("  " ~ space, depth+1) : "(null)";
            return format!"%s\n%s%dL:%s\n%s%dR:%s"(key, space, depth, l, space, depth, r);
        }
    }

    Node* root;

    string toString() {
        return this.root._toString;
    }

    void insert(T t) {
        this.root = this.insert(new Node(t), this.root);
    }

    @nogc nothrow:

    Node* insert(Node* src, Node* dst) {
        if (dst is null) return src;
        if (compare(src.key, dst.key)) {
            dst.left = this.insert(src, dst.left);
        } else {
            dst.right = this.insert(src, dst.right);
        }
        ++dst.size;
        return balance(dst);
    }

    pure find(T key) { return find(this.root, key); }

    pure find(Node* node, T key) {
        if (node is null) {
            return null;
        } else if (key == node.key) {
            return node;
        } else if (compare(key, node.key)) {
            return this.find(node.left, key);
        } else {
            return this.find(node.right, key);
        }
    }

    pure height(Node* node) {
        return node is null ? 0 : node.height;
    }

    pure size(Node* node) {
        return node is null ? 0 : node.size;
    }

    void updateSize(Node* node) {
        if (node !is null) {
            node.size = size(node.left) + size(node.right) + 1;
        }
    }

    Node* rotate(Node* node, int i) {
        Node* tmp = node.child[1-i];
        node.child[1-i] = tmp.child[i];
        tmp.child[i] = balance(node);
        this.updateSize(node);
        this.updateSize(tmp);
        return balance(tmp);
    }

    Node* balance(Node* node) {
        // static
        foreach (i; [0, 1]) {
            // unbalanced. child[i] is 1 height higher than child[1-i]
            if (height(node.child[1-i]) + 1 < height(node.child[i])) {
                auto higher = node.child[i];
                // higher side (left/right) is not higher in its child
                if (height(higher.child[i]) < height(higher.child[1-i])) {
                    node.child[i] = this.rotate(higher, i);
                }
                return this.rotate(node, 1-i);
            }
        }
        if (node !is null) {
            node.height = max(height(node.left), height(node.right)) + 1;
            this.updateSize(node);
        }
        return node;
    }

    /// O(log n)
    pure Node* nth(size_t k) {
        return this.nth(k, this.root);
    }

    pure Node* nth(size_t k, Node* node) {
        if (node is null) return null;
        auto m = this.size(node.left);
        if (k < m) return this.nth(k, node.left);
        else if (k == m) return node;
        else return this.nth(k-m-1, node.right);
    }

    void remove(T key) {
        if (this.find(key) is null) return;
        this.root = remove(this.root, key);
    }

    Node* remove(Node* node, T key) {
        if (node is null) return null;
        else if (key == node.key) {
            return this.moveDown(node.left, node.right);
        } else {
            if (compare(key, node.key)) {
                node.left = this.remove(node.left, key);
            } else {
                node.right = this.remove(node.right, key);
            }
            --node.size;
            return this.balance(node);
        }
    }

    Node* moveDown(Node* node, Node* rhs) {
        if (node is null) return rhs;
        node.right = moveDown(node.right, rhs);
        return this.balance(node);
    }
}
